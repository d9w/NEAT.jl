
cfg = get_config("test.yaml")

@testset "Individual" begin

    ind = NEATInd(cfg)

    n_nodes = cfg["n_in"] + cfg["n_out"]
    @test length(ind.node_genes) == n_nodes
    @test length(ind.conn_genes) == cfg["n_in"] * cfg["n_out"]
    weights = []
    for c in ind.conn_genes
        @test c.in_node <= maximum(ind.node_genes)
        @test c.out_node <= maximum(ind.node_genes)
        @test c.weight < Inf && c[3] > -Inf
        push!(weights, c.weight)
        @test c.enabled == 0 || c[4] == 1
        @test c.innovation < length(ind.conn_genes)
    end

    @test length(unique(weights)) > 1
end
