# Julia startup script for Dissertation project
# This file is copied to .julia/config/startup.jl by the Nix flake

try
    using Revise
    @info "Revise.jl loaded - automatic code reloading enabled"
catch e
    @warn "Revise.jl not available" exception=e
end
