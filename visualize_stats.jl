using DataFrames, CSV, CairoMakie, Statistics

# Set a theme (optional, requires Makie)
set_theme!(theme_light())

# Define input/output directory
output_dir = "output"
in_dist_file = joinpath(output_dir, "place_category_distributions.csv")
in_cooc_file = joinpath(output_dir, "place_category_cooccurrence.csv")
in_corr_file = joinpath(output_dir, "place_category_correlation.csv")
out_bar_file = joinpath(output_dir, "place_distribution_barplot.png")
out_heatmaps_combined_file = joinpath(output_dir, "place_cooc_corr_heatmaps.png") # Combined output
out_heatmap_cooc_file = joinpath(output_dir, "place_cooccurrence_heatmap.png")   # Individual cooc output
out_heatmap_corr_file = joinpath(output_dir, "place_correlation_heatmap.png")    # Individual corr output

# --- Generate Bar Plot for Place Distributions ---
println("Loading place category distributions from $in_dist_file...")
if !isfile(in_dist_file)
    error("Distribution file not found: $in_dist_file. Run main.jl first.")
end
place_distributions = CSV.read(in_dist_file, DataFrame)

# Sort for better visualization
sort!(place_distributions, :count, rev=true)

println("Generating distribution bar plot...")
fig_bar = Figure(size = (800, 600))
ax_bar = Axis(fig_bar[1, 1],
            xticks = (1:nrow(place_distributions), place_distributions.category),
            xticklabelrotation = pi/4,
            title = "Distribution of Place Categories by Street Count",
            ylabel = "Number of Streets")
barplot!(ax_bar, 1:nrow(place_distributions), place_distributions.count)
save(out_bar_file, fig_bar)
println("Saved distribution bar plot to $out_bar_file")

# --- Load Data for Heatmaps ---
println("Loading place category co-occurrence from $in_cooc_file...")
if !isfile(in_cooc_file)
    error("Co-occurrence file not found: $in_cooc_file. Run main.jl first.")
end
cooccurrence_df = CSV.read(in_cooc_file, DataFrame)

println("Loading place category correlation from $in_corr_file...")
if !isfile(in_corr_file)
    error("Correlation file not found: $in_corr_file. Run main.jl first.")
end
correlation_df = CSV.read(in_corr_file, DataFrame)

# Prepare data for heatmaps (assuming categories are the same and in the same order)
category_labels = cooccurrence_df.category # Use labels from one (should be identical)
cooccurrence_matrix = Matrix(cooccurrence_df[:, 2:end])
correlation_matrix = Matrix(correlation_df[:, 2:end])

# --- Generate Combined Heatmap Figure ---
println("Generating combined heatmaps...")
fig_heat_combined = Figure(size = (1600, 800)) # Wider figure for two plots

# Co-occurrence Heatmap (Left side of combined)
ax_cooc_comb = Axis(fig_heat_combined[1, 1], # Position [row, col]
            xticks = (1:length(category_labels), category_labels),
            yticks = (1:length(category_labels), category_labels),
            xticklabelrotation = pi/4,
            title = "Co-occurrence of Place Categories",
            aspect = DataAspect())
hm_cooc_comb = heatmap!(ax_cooc_comb, cooccurrence_matrix, colormap = :viridis)
Colorbar(fig_heat_combined[1, 2], hm_cooc_comb, label = "Co-occurrence Count")

# Correlation Heatmap (Right side of combined)
ax_corr_comb = Axis(fig_heat_combined[1, 3], # Position [row, col]
            xticks = (1:length(category_labels), category_labels),
            yticks = (1:length(category_labels), category_labels),
            xticklabelrotation = pi/4,
            title = "Correlation of Place Categories",
            aspect = DataAspect())
hm_corr_comb = heatmap!(ax_corr_comb, correlation_matrix, colormap = :RdBu, colorrange = (-1, 1))
Colorbar(fig_heat_combined[1, 4], hm_corr_comb, label = "Pearson Correlation")

save(out_heatmaps_combined_file, fig_heat_combined) # Save the combined figure
println("Saved combined heatmaps to $out_heatmaps_combined_file")

# --- Generate Individual Co-occurrence Heatmap ---
println("Generating individual co-occurrence heatmap...")
fig_heat_cooc = Figure(size = (800, 800))
ax_cooc_indiv = Axis(fig_heat_cooc[1, 1],
                xticks = (1:length(category_labels), category_labels),
                yticks = (1:length(category_labels), category_labels),
                xticklabelrotation = pi/4,
                title = "Co-occurrence of Place Categories",
                aspect = DataAspect())
hm_cooc_indiv = heatmap!(ax_cooc_indiv, cooccurrence_matrix, colormap = :viridis)
Colorbar(fig_heat_cooc[1, 2], hm_cooc_indiv, label = "Co-occurrence Count")
save(out_heatmap_cooc_file, fig_heat_cooc) # Save the individual cooc figure
println("Saved individual co-occurrence heatmap to $out_heatmap_cooc_file")

# --- Generate Individual Correlation Heatmap ---
println("Generating individual correlation heatmap...")
fig_heat_corr = Figure(size = (800, 800))
ax_corr_indiv = Axis(fig_heat_corr[1, 1],
                xticks = (1:length(category_labels), category_labels),
                yticks = (1:length(category_labels), category_labels),
                xticklabelrotation = pi/4,
                title = "Correlation of Place Categories",
                aspect = DataAspect())
hm_corr_indiv = heatmap!(ax_corr_indiv, correlation_matrix, colormap = :RdBu, colorrange = (-1, 1))
Colorbar(fig_heat_corr[1, 2], hm_corr_indiv, label = "Pearson Correlation")
save(out_heatmap_corr_file, fig_heat_corr) # Save the individual corr figure
println("Saved individual correlation heatmap to $out_heatmap_corr_file")

# Optional text labels could be added to individual plots here if desired

println("Visualization script finished.")
