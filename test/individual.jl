
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
        @test c.innovation > cfg["innovation_max"]
        @test c.innovation <= length(ind.connections) + cfg["innovation_max"]
    end

    @test length(unique(weights)) > 1
end
