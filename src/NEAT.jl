module NEAT

using Cambrian
using YAML
using JSON
using Random
using LinearAlgebra

include("config.jl")
include("individual.jl")
include("process.jl")
include("mutation.jl")
# include("crossover.jl")

end
