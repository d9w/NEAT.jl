
cfg = get_config("test.yaml")
cfg["innovation_max"] = 5

@testset "Individual" begin

    ind = NEATInd(cfg)

    n_nodes = cfg["n_in"] + cfg["n_out"]
    @test length(ind.node_genes) == n_nodes
    @test length(ind.connections) == cfg["n_in"] * cfg["n_out"]
    weights = []
    for c in ind.connections
        @test c.in_node <= maximum(ind.node_genes)
        @test c.out_node <= maximum(ind.node_genes)
        @test c.weight < Inf && c.weight > -Inf
        push!(weights, c.weight)
        @test c.enabled || ~c.enabled
        @test c.innovation <= cfg["innovation_max"]
        @test c.innovation <= length(ind.connections) + cfg["innovation_max"]
    end

    @test length(unique(weights)) > 1
end


@testset "Reconstruct individual" begin

    ind = NEATInd(cfg)
    for c in ind.connections
        c.weight = rand()
        if rand() < 0.5
            c.enabled = false
        end
    end

    string_ind = string(ind)
    @test typeof(string_ind) == String

    ind2 = NEATInd(cfg, string_ind)

    for i in eachindex(ind.connections)
        @test ind.connections[i].in_node == ind2.connections[i].in_node
        @test ind.connections[i].out_node == ind2.connections[i].out_node
        @test ind.connections[i].weight == ind2.connections[i].weight
        @test ind.connections[i].enabled == ind2.connections[i].enabled
        @test ind.connections[i].innovation == ind2.connections[i].innovation
    end

    @test all(ind.node_genes .== ind2.node_genes)
    @test all(ind.fitness .== ind2.fitness)
end
