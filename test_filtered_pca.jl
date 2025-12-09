#!/usr/bin/env julia

# Quick test script to verify filtered types PCA works

using Dissertation

println("="^80)
println("Testing Filtered Multi-Type PCA Implementation")
println("="^80)

# Run PCA diagnostics with new filtered types approach
println("\nRunning PCA diagnostics...")
Dissertation.run_pca_diagnostics()

println("\n" * "="^80)
println("Test complete! Check output/sensitivity/ for results")
println("="^80)
