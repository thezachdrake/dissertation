"""
Co-occurrence analysis for RQ1: Do different place types cluster together?

Counts how often pairs of place types show up on the same streets.
"""

"""
Build a matrix showing how often place types appear together.

Counts streets where both type A and type B exist. The diagonal
shows how many streets have that type at all. Better than correlation
because it shows raw counts, not just relationships.

Returns the co-occurrence matrix and list of place types used.
"""
function calculate_cooccurrence_matrix(
    features::DataFrame
)::Tuple{DataFrame, Vector{Symbol}}
    @info "Calculating place type co-occurrence matrix..."

    # Identify place columns (exclude crime, metadata, derived columns, and OTHER category)
    place_cols = Symbol[]
    for col in names(features)
        col_str = String(col)
        # Include only place-related numeric columns (exclude OTHER, interactions, and metadata)
        if !startswith(col_str, "crime_") &&
            !startswith(col_str, "high_") &&
            !startswith(col_str, "interact_") &&  # Exclude interaction terms
            !startswith(col_str, "PC_") &&         # Exclude PCA components
            col_str != "OTHER" &&                  # Exclude OTHER catch-all category
            !in(
                col,
                [
                    :street_id,
                    :street_name,
                    :total_crime,
                    :total_places,
                    :crime_place_ratio,
                    :commercial_activity,
                    :street_length_meters,
                    :place_density
                ]
            ) &&
            eltype(features[!, col]) <: Number
            push!(place_cols, Symbol(col))
        end
    end

    n_places = length(place_cols)
    @info "Found $(n_places) place categories for co-occurrence analysis"

    if n_places == 0
        @warn "No place columns found for co-occurrence analysis"
        return DataFrame(), Symbol[]
    end

    # Initialize co-occurrence matrix
    cooc_matrix = zeros(Int, n_places, n_places)

    # Calculate co-occurrences
    # For each pair of place types, count how many street segments have both
    for i = 1:n_places
        for j = i:n_places
            col_i = place_cols[i]
            col_j = place_cols[j]

            if i == j
                # Diagonal: count of streets with this place type present
                cooc_matrix[i, j] = sum(features[!, col_i] .> 0)
            else
                # Off-diagonal: count of streets with both place types present
                cooc_count = sum((features[!, col_i] .> 0) .& (features[!, col_j] .> 0))
                cooc_matrix[i, j] = cooc_count
                cooc_matrix[j, i] = cooc_count  # Matrix is symmetric
            end
        end
    end

    # Create DataFrame for better display and analysis
    cooc_df = DataFrame(cooc_matrix, Symbol.(place_cols))
    insertcols!(cooc_df, 1, :category => String.(place_cols))

    # Log summary statistics
    total_cooccurrences = sum(cooc_matrix[i, j] for i = 1:n_places for j = (i + 1):n_places)
    max_cooccurrence = maximum(
        cooc_matrix[i, j] for i = 1:n_places for j = (i + 1):n_places if i != j
    )

    @info "Co-occurrence matrix calculated:"
    @info "  Matrix size: $(n_places)×$(n_places)"
    @info "  Total co-occurrences: $(total_cooccurrences)"
    @info "  Maximum co-occurrence count: $(max_cooccurrence)"

    return cooc_df, place_cols
end

"""
    analyze_cooccurrence_patterns(cooc_df::DataFrame, place_cols::Vector{Symbol})::DataFrame

Analyze and summarize co-occurrence patterns to answer Research Question 1.
Identifies which place types most frequently co-locate on street segments.

This function operationalizes the theoretical concept of activity nodes from
routine activities theory. As discussed in the paper, certain types of facilities
may create "crime generators" and "crime attractors" (Brantingham and Brantingham,
1995) through their co-location patterns. The analysis reveals which facility
combinations are most common in Manhattan, providing insight into the urban
ecology of crime opportunity.

The Jaccard similarity coefficient is calculated to normalize co-occurrence by
the total presence of each place type, addressing the issue that common place
types will naturally co-occur more frequently. Conditional probabilities reveal
asymmetric relationships between place types.

Arguments:

  - cooc_df: Co-occurrence matrix from calculate_cooccurrence_matrix()
  - place_cols: Vector of place category symbols

Returns:

  - DataFrame: All unique place pairs with metrics:

      + place1, place2: Names of co-occurring place types
      + cooccurrence_count: Raw count of co-occurrence
      + place1_count: Total streets with place1
      + place2_count: Total streets with place2
      + jaccard_similarity: Intersection/union measure (0-1)
      + prob_place2_given_place1: P(place2 | place1)
      + prob_place1_given_place2: P(place1 | place2)

Interpretation Guidelines:

  - High cooccurrence_count: Frequent pairing in absolute terms
  - High Jaccard similarity: Strong association relative to individual frequencies
  - Asymmetric conditional probabilities: Directional dependencies between types
  - Results sorted by cooccurrence_count (descending)
"""
function analyze_cooccurrence_patterns(
    cooc_df::DataFrame, place_cols::Vector{Symbol}
)::DataFrame
    @info "Analyzing co-occurrence patterns..."

    if isempty(place_cols)
        @warn "No place columns to analyze"
        return DataFrame()
    end

    # Extract all unique pairs from upper triangle (excluding diagonal)
    pairs = []
    n = length(place_cols)

    for i = 1:n
        for j = (i + 1):n
            # Get co-occurrence count from matrix
            cooc_count = cooc_df[i, place_cols[j]]

            # Get individual counts from diagonal
            count_i = cooc_df[i, place_cols[i]]
            count_j = cooc_df[j, place_cols[j]]

            # Calculate Jaccard similarity coefficient
            # Jaccard = intersection / union = cooc / (count_i + count_j - cooc)
            union_count = count_i + count_j - cooc_count
            jaccard = union_count > 0 ? cooc_count / union_count : 0.0

            # Calculate conditional probabilities
            # P(j|i) = probability of finding place j given place i exists
            prob_j_given_i = count_i > 0 ? cooc_count / count_i : 0.0
            # P(i|j) = probability of finding place i given place j exists
            prob_i_given_j = count_j > 0 ? cooc_count / count_j : 0.0

            push!(
                pairs,
                (
                    place1 = String(place_cols[i]),
                    place2 = String(place_cols[j]),
                    cooccurrence_count = cooc_count,
                    place1_count = count_i,
                    place2_count = count_j,
                    jaccard_similarity = jaccard,
                    prob_place2_given_place1 = prob_j_given_i,
                    prob_place1_given_place2 = prob_i_given_j
                )
            )
        end
    end

    # Convert to DataFrame
    pairs_df = DataFrame(pairs)

    if nrow(pairs_df) == 0
        @warn "No place pairs found for analysis"
        return pairs_df
    end

    # Sort by co-occurrence count (descending)
    sort!(pairs_df, :cooccurrence_count; rev = true)

    # Log top co-occurring pairs
    @info "Top 10 co-occurring place type pairs:"
    for i = 1:min(10, nrow(pairs_df))
        row = pairs_df[i, :]
        pct1 = round(100 * row.prob_place2_given_place1; digits = 1)
        pct2 = round(100 * row.prob_place1_given_place2; digits = 1)
        @info "  $(row.place1) & $(row.place2): $(row.cooccurrence_count) streets"
        @info "    - $(pct1)% of $(row.place1) segments also have $(row.place2)"
        @info "    - $(pct2)% of $(row.place2) segments also have $(row.place1)"
        @info "    - Jaccard similarity: $(round(row.jaccard_similarity, digits=3))"
    end

    # Calculate some summary statistics
    avg_jaccard = mean(pairs_df.jaccard_similarity)
    high_cooc_pairs = sum(pairs_df.cooccurrence_count .> 100)

    @info "Summary statistics:"
    @info "  Average Jaccard similarity: $(round(avg_jaccard, digits=3))"
    @info "  Pairs with >100 co-occurrences: $(high_cooc_pairs)"

    return pairs_df
end

"""
    save_cooccurrence_results(cooc_df::DataFrame, pairs_df::DataFrame, output_dir::String)::Nothing

Save co-occurrence analysis results to CSV files and generate summary report.

This function creates persistent outputs for Research Question 1 analysis,
ensuring reproducibility and enabling further exploration of place co-location
patterns. The outputs are structured to facilitate both academic reporting
and practical application for urban planning and crime prevention.

Arguments:

  - cooc_df: Co-occurrence matrix from calculate_cooccurrence_matrix()
  - pairs_df: Analyzed pairs from analyze_cooccurrence_patterns()
  - output_dir: Directory path for saving results

Outputs Created:

  - cooccurrence_matrix.csv: Full co-occurrence matrix
  - cooccurrence_pairs.csv: Pairwise analysis with all metrics
  - cooccurrence_summary.md: Markdown report with key findings

File Formats:

  - CSV files: Standard format for statistical software import
  - Markdown report: Human-readable summary with tables and interpretation

The summary report includes top co-occurring pairs formatted as a table,
connecting findings to the theoretical framework of routine activities
and crime opportunity structures discussed in the paper.
"""
function save_cooccurrence_results(
    cooc_df::DataFrame, pairs_df::DataFrame, output_dir::String
)::Nothing
    # Create output directory if it doesn't exist
    mkpath(output_dir)

    # Save co-occurrence matrix
    matrix_path = joinpath(output_dir, "cooccurrence_matrix.csv")
    CSV.write(matrix_path, cooc_df)
    @info "Saved co-occurrence matrix to $(matrix_path)"

    # Save pairs analysis
    pairs_path = joinpath(output_dir, "cooccurrence_pairs.csv")
    CSV.write(pairs_path, pairs_df)
    @info "Saved co-occurrence pairs analysis to $(pairs_path)"

    # Create a summary report
    report_path = joinpath(output_dir, "cooccurrence_summary.md")
    open(report_path, "w") do io
        println(io, "# Place Type Co-occurrence Analysis\n")
        println(io, "## Research Question 1: Do places of different types co-locate?\n")

        if !isempty(pairs_df)
            println(io, "### Key Findings\n")
            println(io, "- Total place type pairs analyzed: $(nrow(pairs_df))")
            println(
                io,
                "- Average Jaccard similarity: $(round(mean(pairs_df.jaccard_similarity), digits=3))"
            )
            println(
                io, "- Maximum co-occurrence count: $(maximum(pairs_df.cooccurrence_count))"
            )

            println(io, "\n### Top 5 Co-occurring Place Types\n")
            println(
                io,
                "| Place Type 1 | Place Type 2 | Co-occurrence Count | Jaccard Similarity |"
            )
            println(
                io,
                "|--------------|--------------|--------------------:|-------------------:|"
            )

            for i = 1:min(5, nrow(pairs_df))
                row = pairs_df[i, :]
                println(
                    io,
                    "| $(row.place1) | $(row.place2) | $(row.cooccurrence_count) | $(round(row.jaccard_similarity, digits=3)) |"
                )
            end

            println(io, "\n### Interpretation\n")
            println(
                io,
                "The co-occurrence matrix reveals patterns in how different types of places cluster together on street segments."
            )
            println(
                io,
                "High co-occurrence counts indicate place types that frequently appear together, suggesting"
            )
            println(
                io,
                "similar locational preferences or complementary functions in the urban environment."
            )
        else
            println(io, "No place type pairs found for analysis.")
        end
    end

    @info "Saved co-occurrence summary report to $(report_path)"
end

"""
    run_cooccurrence_analysis(features::DataFrame; output_dir::String = joinpath(OUTPUT_DIR, "cooccurrence"))::Dict{Symbol, Any}

Complete co-occurrence analysis pipeline for Research Question 1:
"Do places of different types co-locate with each other at higher rates?"

This function orchestrates the full analysis workflow to assess facility
co-location patterns on Manhattan street segments. The analysis provides
empirical evidence for understanding how different types of places cluster
in urban space, which is fundamental to crime opportunity theory.

As discussed in the paper, the co-occurrence approach is preferred over
correlation because it captures "the raw magnitude and frequency of the
co-location" which is theoretically important for understanding the
absolute scale of routine activity convergence at street segments.

The results inform understanding of:

 1. Natural clustering of urban facilities
 2. Potential crime generators through facility combinations
 3. Place management implications of co-located facilities
 4. Routine activity patterns in urban environments

Arguments:

  - features: DataFrame containing:

      + street_id: Unique street segment identifiers
      + Place type columns: Integer counts per segment
      + Crime and other columns (automatically filtered)

  - output_dir: Directory for saving results (default: OUTPUT_DIR/cooccurrence)

Returns:

  - Dict{Symbol, Any} containing:

      + :cooccurrence_matrix: Full co-occurrence DataFrame
      + :pairs_analysis: Analyzed pairs with metrics
      + :place_categories: Vector of analyzed place types
      + :output_directory: Path where results were saved
      + :error (optional): Error message if analysis failed

Process Flow:

 1. Calculate co-occurrence matrix from street features
 2. Analyze pairwise patterns with multiple metrics
 3. Save results to CSV and markdown files
 4. Log key findings to console
 5. Return comprehensive results dictionary

Quality Checks:

  - Validates presence of place columns
  - Handles empty datasets gracefully
  - Logs progress at each stage
  - Creates output directory if needed
"""
function run_cooccurrence_analysis(
    features::DataFrame; output_dir::String = joinpath(OUTPUT_DIR, "cooccurrence")
)::Dict{Symbol, Any}
    @info "="^60
    @info "RESEARCH QUESTION 1: Place Type Co-location Analysis"
    @info "="^60

    # Calculate co-occurrence matrix
    cooc_df, place_cols = calculate_cooccurrence_matrix(features)

    if isempty(place_cols)
        @error "No place columns found in features DataFrame"
        return Dict(:error => "No place data available")
    end

    # Analyze co-occurrence patterns
    pairs_df = analyze_cooccurrence_patterns(cooc_df, place_cols)

    # Save results
    save_cooccurrence_results(cooc_df, pairs_df, output_dir)

    @info "Co-occurrence analysis complete. Results saved to $(output_dir)"

    return Dict(
        :cooccurrence_matrix => cooc_df,
        :pairs_analysis => pairs_df,
        :place_categories => place_cols,
        :output_directory => output_dir
    )
end
