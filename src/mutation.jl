export mutate

"Mutate: Change weights"
function mutate_weights(indiv::NEATInd, cfg::Dict)
    # TODO: check original weight mutation
    ind = NEATInd(indiv)
    for c in ind.connections
        if rand() < cfg["p_mut_weights"]
            c.weight = c.weight + randn()*cfg["weight_factor"]
        end
    end
    ind
end

"split a connection by adding a neuron"
function split_connection(c::Connection, neuron_nb::Int, cfg::Dict)
    # Create neuron
    n = Neuron(0.0, 0.0, false)

    # Create 2 new connections
    # TODO: neuron number does not correspond to order for recurrence checks
    c1 = Connection(c.in_node, neuron_nb, 1.0, true, cfg["innovation_max"]+1)
    c2 = Connection(neuron_nb, c.out_node, c.weight, true, cfg["innovation_max"]+2)
    cfg["innovation_max"] += 2

    c1, c2, n
end

"Mutation: Add a node in a connection"
function mutate_add_neuron(indiv::NEATInd, cfg::Dict)
    ind = NEATInd(indiv)

    ci = rand(1:length(ind.connections))
    c = ind.connections[ci]
    c1, c2, n = split_connection(c, length(ind.neurons), cfg)
    deleteat!(ind.connections, ci)
    append!(ind.connections, [c1, c2])
    push!(ind.neurons, n)

    ind
end

"Mutation: Add a connection between 2 random nodes"
function mutate_add_connection(indiv::NEATInd, cfg::Dict, allow_recurrent::Bool=false)
    ind = NEATInd(indiv)

    # Select 2 different neurons at random, can't create a connection that already exists
    nn = length(ind.neurons)
    valid = trues(nn, nn)
    for c in ind.connections
        valid[c.in_node, c.out_node] = false
    end
    conns = findall(valid)
    if length(conns) > 0
        shuffle!(conns)
        cfg["innovation_max"] += 1
        c = Connection(conns[1][1], conns[1][2], rand_weight(), true, cfg["innovation_max"])
        push!(ind.connections, c)
    end

    ind
end

"Mutation: Toggle Enabled"
function mutate_enabled(indiv::NEATInd; n_times=1)
    ind = NEATInd(indiv)
    ids = randperm(length(ind.connections))
    for i in 1:n_times
        ind.connections[ids[i]].enabled = !ind.connections[ids[i]].enabled
    end
    ind
end

"mutate(ind::NEATInd, cfg::Dict): return a new mutated individual"
function mutate(indiv::NEATInd, cfg::Dict)
    if rand() < cfg["p_mutate_add_neuron"]
        return mutate_add_neuron(indiv, cfg)
    elseif rand() < cfg["p_mutate_add_connection"]
        return mutate_add_connection(indiv, cfg)
    elseif rand() < cfg["p_mutate_weights"]
        return mutate_weights(indiv, cfg)
    elseif rand() < cfg["p_mutate_enable"]
        return mutate_enabled(indiv, cfg)
    end
    # return clone if no mutation occurs
    NEATInd(indiv)
end
