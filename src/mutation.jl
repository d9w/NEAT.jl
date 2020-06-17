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
    NEATInd(indiv.n_in, indiv.n_out, indiv.node_genes, new_conn, neurons, fitness=[-Inf])
end

function mutate_weight(conn::Connection, weigth_factor=0.1)
    new_weight::Float64 = conn.weight + randn()*weigth_factor
    Connection(conn.in_node, conn.out_node, new_weight, conn.enabled, conn.innovation)
end

## Mutation: Add a node in a connection

function mutate_add_node(indiv::NEATInd)
    # Choose connection to mutate
    new_conn::Array{Connection}=[]
    new_node_genes::Array{Int} = indiv.node_genes
    for c in indiv.connections
        if rand()>=p_mut
            push!(new_conn, c)
        else
            c1, c2, n = mutate_add_node(c)
            append!(new_conn, )
            push!(new_node_genes, n)
        end
    end
    NEATInd(indiv.n_in, indiv.n_out, indiv.node_genes, new_conn, neurons, fitness=[-Inf])
end

function mutate_add_node(indiv::NEATInd, max_innovation)
    # Choose connection to mutate

    # Create neuron
    n = 0

    # Create 2 new connections
    c1 = Connection(i, n, rand_weight(), true, max_innovation+1)
    c2 = Connection(n, j, rand_weight(), true, max_innovation+2)

    c1, c2, n
end

## Mutation: Add a connection between 2 random nodes

function mutate_add_connection(indiv::NEATInd)

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
    NEATInd(indiv.n_in, indiv.n_out, indiv.node_genes, new_conn, neurons, fitness=[-Inf])
end

function mutate_enabled(conn::Connection)
    Connection(conn.in_node, conn.out_node, conn.weight, !(conn.enabled), conn.innovation)
end
