using DataFrames, CSV, Glob, CairoMakie, Colors, ColorSchemes
using Printf

# Define directories
output_dir = "output"
coeffs_dir = joinpath(output_dir, "model_coefficients")

# Check if coefficient directory exists
if !isdir(coeffs_dir)
    error("Coefficients directory '$coeffs_dir' not found. Run main.jl first.")
end

# Find all coefficient CSV files
csv_files = glob("*_coeffs.csv", coeffs_dir)

if isempty(csv_files)
    error("No coefficient CSV files found in '$coeffs_dir'. Run main.jl first.")
end

println("Loading coefficient data from $(length(csv_files)) files...")
all_coeffs = DataFrame()

# Load and combine data from all files
for file_path in csv_files
    # Extract model name, expecting format like top_XX_source_CRIMETYPE or top_jenks_manual_source_CRIMETYPE
    model_name_str = replace(basename(file_path), "_coeffs.csv" => "")
    parts = split(model_name_str, '_')
    
    threshold::String = ""
    source::String = ""
    crime_type::String = ""
    model_label::String = ""

    if length(parts) >= 5 && parts[1] == "top" && parts[2] == "jenks" && parts[3] == "manual"
        # Handle Jenks: top_jenks_manual_SOURCE_CRIMETYPE
        threshold = "Jenks"
        source = parts[4]      # e.g., "incidents"
        crime_type = join(parts[5:end], '_') # Handle crime types with underscores if they exist
        if !(source in ["incidents", "arrests"])
             @warn "Unexpected source '$source' in Jenks model name: '$model_name_str' in file $file_path. Skipping."
             continue
        end
        model_label = "$(uppercasefirst(source)) Jenks" # e.g., "Incidents Jenks"

    elseif length(parts) >= 4 && parts[1] == "top" && parts[2] in ["25", "50"]
        # Handle Percentile: top_XX_SOURCE_CRIMETYPE
        threshold = parts[2]
        source = parts[3]
        crime_type = join(parts[4:end], '_') # Handle crime types with underscores
         if !(source in ["incidents", "arrests"])
             @warn "Unexpected source '$source' in percentile model name: '$model_name_str' in file $file_path. Skipping."
             continue
        end
        model_label = "$(uppercasefirst(source)) $(threshold)%" # e.g., "Incidents 25%"
    else
        @warn "Unexpected model name format: '$model_name_str' in file $file_path. Skipping."
        continue
    end
    
    try
        df = CSV.read(file_path, DataFrame)
        df[!, :model] .= Symbol(model_name_str) # Keep original symbol if needed
        df[!, :crime_type] .= crime_type
        df[!, :source] .= source
        df[!, :threshold] .= threshold # Will be "25", "50", or "Jenks"
        df[!, :model_label] .= model_label # Will be "Incidents 25%", "Arrests 50%", "Incidents Jenks", etc.
        append!(all_coeffs, df)
    catch e
        @warn "Error reading file $file_path: $e. Skipping."
    end
end

if nrow(all_coeffs) == 0
    error("Failed to load any coefficient data.")
end

println("Processing coefficient data...")
# Filter for category predictors (exclude intercept)
filter!(row -> startswith(string(row.predictor), "category_"), all_coeffs)

# Add significance alpha
all_coeffs.alpha = [p < 0.05 ? 1.0 : 0.5 for p in all_coeffs.p_value]

# --- Group by Crime Type and Generate Plots ---

# Consistent mapping for model labels within each plot
model_order = ["Incidents 25%", "Incidents 50%", "Arrests 25%", "Arrests 50%", "Incidents Jenks", "Arrests Jenks"]
model_map = Dict(label => i for (i, label) in enumerate(model_order))
model_colors = ColorSchemes.Set1_6.colors # Use a 6-color scheme

grouped_coeffs = groupby(all_coeffs, :crime_type)

println("Generating plots for each crime type...")

for (key, crime_df) in pairs(grouped_coeffs)
    crime_type = key.crime_type
    println("  Generating plot for: $crime_type")

    # Prepare data for this crime type's plot
    df = DataFrame(crime_df) # Convert SubDataFrame to DataFrame for modification
    filter!(row -> row.model_label in model_order, df) # Ensure only expected models are present
    if nrow(df) == 0
        @warn "No valid data found for crime type '$crime_type'. Skipping plot."
        continue
    end
    
    df.model_idx = [model_map[label] for label in df.model_label]
    df.plot_color = [model_colors[idx] for idx in df.model_idx]

    # Get unique predictors for this crime type
    predictors = sort(unique(df.predictor))
    predictor_map = Dict(p => i for (i, p) in enumerate(predictors))
    df.predictor_idx = [predictor_map[p] for p in df.predictor]

    # Clean predictor names for labels (remove "category_")
    predictor_labels = [replace(string(p), "category_" => "") for p in predictors]

    # Generate Plot
    fig = Figure(size = (1000, 700))
    ax = Axis(fig[1, 1],
              xticks = (1:length(predictors), predictor_labels),
              xticklabelrotation = pi/4,
              title = "Logistic Regression Coefficients for $crime_type",
              ylabel = "Coefficient Estimate",
              xlabel = "Place Category Predictor")

    # Create dodged bars with alpha for significance
    barplot!(
        ax,
        df.predictor_idx,          # x position (predictor category)
        df.coefficient,           # y value (coefficient)
        dodge = df.model_idx,     # Dodging based on model index (1-6)
        color = tuple.(df.plot_color, df.alpha) # Color by model + alpha for significance
    )

    # Add legend for models and significance
    model_elems = [PolyElement(color = model_colors[i], strokecolor = :transparent) for i in 1:6]
    # Use MarkerElement for significance representation
    sig_elems = [
        MarkerElement(color = RGBAf(0.5,0.5,0.5,1.0), marker = :rect, markersize = 15), # Solid grey square (p<0.05)
        MarkerElement(color = RGBAf(0.5,0.5,0.5,0.5), marker = :rect, markersize = 15)  # Transparent grey square (p>=0.05)
    ]
    # Combine elements and labels
    all_elems = [model_elems..., sig_elems...]
    all_labels = [model_order..., "p < 0.05", "p >= 0.05"]
    
    # Create the legend with a single title
    Legend(fig[1, 2], 
           all_elems, 
           all_labels, 
           "Legend") 

    # Save the plot
    plot_output_file = joinpath(output_dir, @sprintf("model_coefficient_comparison_%s.png", crime_type))
    try
        save(plot_output_file, fig)
        println("    Saved plot to $plot_output_file")
    catch e
        @error "Failed to save plot $plot_output_file: $e"
    end
end

println("Model visualization script finished.")
