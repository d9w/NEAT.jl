export NEATInd
import Base: print

mutable struct Connection
    in_node::Int
    out_node::Int
    weight::Float64
    enabled::Bool
    innovation::Int
end

mutable struct Neuron
    input::Float64
    output::Float64
    processed::Bool
end

struct NEATInd <: Cambrian.Individual
    n_in::Int
    n_out::Int
    n_hidden::Int
    connections::Array{Connection}
    neurons::Array{Neuron}
    fitness::Array{Float64}
end

function rand_weight()
    rand() * 2.0 - 1.0 # initial weight is uniformly distributed between -1 and 1
end

function NEATInd(cfg::Dict)
    innovation = cfg["innovation_max"]
    n_in = cfg["n_in"]
    n_out = cfg["n_out"]
    connections = Array{Connection}(undef, 0)
    for i in 1:n_in
        for j in 1:n_out
            innovation += 1
            c = Connection(i, n_in + j, rand_weight(), true, innovation)
            push!(connections, c)
        end
    end
    cfg["innovation_max"]= innovation
    neurons = Array{Neuron}(undef, 0)
    for i in 1:(n_in+n_out)
        push!(neurons, Neuron(0.0, 0.0, false))
    end
    fitness = -Inf .* ones(cfg["d_fitness"])
    NEATInd(n_in, n_out, 0, connections, neurons, fitness)
end

"""clone an individual and give new fitness values"""
function NEATInd(ind::NEATInd)
    ind2 = deepcopy(ind)
    ind2.fitness .= -Inf
    ind2
end

# TODO: remove, already in abstracting branch of Cambrian.jl
function print(io::IO, ind::NEATInd)
    print(io, JSON.json(ind))
end

function String(ind::NEATInd)
    string(ind)
end

function NEATInd(cfg::Dict, ind_s::String)
    d = JSON.parse(ind_s)
    n_in = d["n_in"]
    n_out = d["n_out"]
    n_hidden = d["n_hidden"]
    connections = Array{Connection}(undef, 0)
    for ci in d["connections"]
        c = Connection(ci["in_node"], ci["out_node"],
                       ci["weight"], ci["enabled"], ci["innovation"])
        push!(connections, c)
    end
    neurons = Array{Neuron}(undef, 0)
    for ni in d["neurons"]
        push!(neurons, Neuron(ni["input"], ni["output"], ni["processed"]))
    end
    fitness = zeros(length(d["fitness"]))
    for i in eachindex(d["fitness"])
        if d["fitness"][i] == nothing
            fitness[i] = -Inf
        else
            fitness[i] = Float64(d["fitness"][i])
        end
    end
    NEATInd(n_in, n_out, n_hidden, connections, neurons, fitness)
end
