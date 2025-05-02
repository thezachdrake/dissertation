using DataFrames, CSV, Glob, CairoMakie, Colors, ColorSchemes

# Define directories
output_dir = "output"
coeffs_dir = joinpath(output_dir, "model_coefficients")
plot_output_file = joinpath(output_dir, "model_coefficient_comparison.png")

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
    model_name = Symbol(replace(basename(file_path), "_coeffs.csv" => ""))
    try
        df = CSV.read(file_path, DataFrame)
        df[!, :model] .= model_name # Add model name column
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
filter!(row -> startswith(row.predictor, "category_"), all_coeffs)

# Add significance flag (e.g., p < 0.05)
all_coeffs.significant = all_coeffs.p_value .< 0.05

# --- Prepare for Plotting ---

# Get unique models and predictors for axes
models = unique(all_coeffs.model)
predictors = unique(all_coeffs.predictor)

# Create numerical representation for models and predictors for plotting
model_map = Dict(m => i for (i, m) in enumerate(models))
predictor_map = Dict(p => i for (i, p) in enumerate(predictors))

all_coeffs.model_idx = [model_map[m] for m in all_coeffs.model]
all_coeffs.predictor_idx = [predictor_map[p] for p in all_coeffs.predictor]

# --- Generate Dodged Bar Plot ---
println("Generating dodged bar plot...")

fig = Figure(size = (1200, 800))
ax = Axis(fig[1, 1],
          xticks = (1:length(predictors), string.(predictors)),
          xticklabelrotation = pi/4,
          title = "Logistic Regression Coefficients for Place Categories by Model",
          ylabel = "Coefficient Estimate",
          xlabel = "Place Category Predictor")

# Assign colors using a predefined qualitative scheme with 8 colors
if length(models) == 8
    model_colors = ColorSchemes.Set1_8.colors
else
    # Fallback if the number of models changes unexpectedly
    println("Warning: Expected 8 models, found $(length(models)). Using distinguishable_colors.")
    model_colors = Makie.Colors.distinguishable_colors(length(models), [RGB(1,1,1)])
end

# Create dodged bars
barplot!(
    ax,
    all_coeffs.predictor_idx, # x position (predictor category)
    all_coeffs.coefficient,   # y value (coefficient)
    dodge = all_coeffs.model_idx, # Dodging based on model index
    color = model_colors[all_coeffs.model_idx], # Color by model
    # Use strokecolor/strokewidth to indicate significance
    strokewidth = [sig ? 2 : 0 for sig in all_coeffs.significant],
    strokecolor = :black # Or another contrasting color
)

# Add legend for models
elems = [PolyElement(color = model_colors[i], strokecolor = :transparent) for i in 1:length(models)]
Legend(fig[1, 2], elems, string.(models), "Model (Target Variable)")

save(plot_output_file, fig)
println("Saved coefficient comparison plot to $plot_output_file")

println("Model visualization script finished.")
