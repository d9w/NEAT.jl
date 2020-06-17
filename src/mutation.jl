## Mutate: Change a weight
function mutate_weight(indiv::NEATInd, p_mut=0.1)
    new_conn::Array{Connection}=[]
    for c in indiv.connections
        if rand()>=p_mut
            push!(new_conn, c)
        else
            push!(new_conn, mutate_weight(c))
        end
    end
    NEATInd(indiv.n_in, indiv.n_out, indiv.node_genes, new_conn, indiv.neurons, [-Inf])
end

function mutate_weight(conn::Connection, weigth_factor=0.1)
    new_weight::Float64 = conn.weight + randn()*weigth_factor
    Connection(conn.in_node, conn.out_node, new_weight, conn.enabled, conn.innovation)
end

## Mutation: Add a node in a connection
function mutate_add_neuron(indiv::NEATInd, cfg::Dict)
    # Choose connection to mutate
    new_conn::Array{Connection}=[]
    new_neurons::Array{Neuron} = indiv.neurons
    for c in indiv.connections
        if rand()>=p_mut
            push!(new_conn, c)
        else
            c1, c2, n = mutate_add_neuron(c)
            append!(new_conn, [c1, c2])
            push!(new_neurons, n)
        end
    end
    NEATInd(indiv.n_in, indiv.n_out, collect(1:length(new_neurons)), new_conn, new_neurons, [-Inf])
end

function mutate_add_neuron(indiv::NEATInd, cfg::Dict)
    # Create neuron
    cfg["hidden_neuron_nb"] += 1
    neuron_nb = cfg["hidden_neuron_nb"]
    n = Neuron(0.0, 0.0, false)

    # Create 2 new connections
    c1 = Connection(i, neuron_nb, rand_weight(), true, cfg["innovation_max"]+1)
    c2 = Connection(neuron_nb, j, rand_weight(), true, cfg["innovation_max"]+2)
    cfg["innovation_max"] += 2

    c1, c2, n
end

## Mutation: Add a connection between 2 random nodes
function mutate_add_connection(indiv::NEATInd, cfg::Dict, allow_recurrent::Bool=false)
    # Select 2 different neurons at random
    i = rand(1:length(indiv.neurons))
    j = i
    while j==i
        j = rand(1:length(indiv.neurons))
    end
    if j < i && !allow_recurrent
        i, j = j, i
    end

    # Create new connection
    cfg["innovation_max"]+=1
    new_c = Connection(i, j, rand_weight(), true, cfg["innovation_max"])

    NEATInd(indiv.n_in, indiv.n_out, indiv.node_genes, push!(indiv.connections, new_c), indiv.neurons, [-Inf])
end


## Mutation: Toggle Enabled
function mutate_enabled(indiv::NEATInd, p_mut=0.1)
    new_conn::Array{Connection}=[]
    for c in indiv.connections
        if rand()>=p_mut
            push!(new_conn, c)
        else
            push!(new_conn, mutate_enabled(c))
        end
    end
    NEATInd(indiv.n_in, indiv.n_out, indiv.node_genes, new_conn, neurons, [-Inf])
end

function mutate_enabled(conn::Connection)
    Connection(conn.in_node, conn.out_node, conn.weight, !(conn.enabled), conn.innovation)
end
