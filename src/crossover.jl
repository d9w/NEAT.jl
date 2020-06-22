function crossover(parent1::NEATInd, parent2::NEATInd, cfg::Dict)
    # Get dicts {innovation_number: connection}
    p1_genes=Dict()
    p2_genes=Dict()

    # Add genes or parent 1
    for c in parent1.connections
        p1_genes[c.innovation]= c
    end

    # Add genes or parent 2
    for c in parent2.connections
        p2_genes[c.innovation]= c
    end

    # Get IDs of all neurons used by the individual
    n_in = cfg["n_in"]
    n_out = cfg["n_out"]
    neuron_numbers = Array(1:n_in + n_out) # In / out neurons

    # Child connections
    child_connections::Array{Connection}(undef, 0)
    for i in 1:cfg["innovation_max"]
        new_con = nothing
        # Both parents have the gene: pick random
        if i in keys(p1_genes) && i in keys(p2_genes)
            if rand()>0/5
                new_con =p1_genes[i]
            else
                new_con =p2_genes[i]
            end

        # Only parent1 has the gene: pick if its fitness is higher
        elseif i in keys(p1_genes) and parent1.fitness >= parent2.fitness
            new_con =p1_genes[i]

        # Only parent2 has the gene: pick if its fitness is higher
        elseif i in keys(p2_genes) and parent2.fitness >= parent1.fitness
            new_con =p2_genes[i]
        end

        # Add the connection to the child, add the neuron IDs 
        if new_con != nothing
            push!(child_connections, new_con)
            if !(new_con.in_node in neuron_numbers)
                push!(neuron_numbers, new_con.in_node)
            end
            # Add out_neuron if not already in
            if !(new_con.out_node in neuron_numbers)
                push!(neuron_numbers, new_con.out_node)
            end
        end
    end

    # Child neurons
    neurons = Array{Neuron}(undef, 0)
    for i in 1:length(neuron_numbers)
        push!(neurons, Neuron(0.0, 0.0, false))
    end
    # Child fitness
    fitness = -Inf .* ones(cfg["d_fitness"])
    NEATInd(n_in, n_out, 0, child_connections, neurons, fitness)

end
