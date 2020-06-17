export Connection, NEATInd

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
    node_genes::Array{Int}
    connections::Array{Connection}
    neurons::Array{Neuron}
    fitness::Array{Float64}
end

function rand_weight()
    rand() * 2.0 - 1.0 # initial weight is uniformly distributed between -1 and 1
end

function NEATInd(cfg::Dict)
    innovation = 0
    n_in = cfg["n_in"]
    n_out = cfg["n_out"]
    node_genes = collect(1:(n_in+n_out))
    connections = Array{Connection}(undef, 0)
    for i in 1:n_in
        for j in 1:n_out
            innovation += 1
            c = Connection(i, j, rand_weight(), true, innovation)
            push!(connections, c)
        end
    end
    neurons = Array{Neuron}(undef, 0)
    for i in 1:(n_in+n_out)
        push!(neurons, Neuron(0.0, 0.0, false))
    end
    fitness = [-Inf]
    NEATInd(n_in, n_out, node_genes, connections, neurons, fitness)
end
