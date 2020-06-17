cfg = get_config("test.yaml")
cfg["innovation_max"] = 5

ind = NEATInd(cfg)

@testset "Mutate" begin
    mut_w = NEAT.mutate_weight(ind)
    # @test mut_w.weight != ind.weight

    mut_en = NEAT.mutate_enabled(ind)
    # @test mut_en.enabled != ind.enabled

    mut_add_con = NEAT.mutate_add_connection(ind, cvg)
    # @test len(mut_add_con.connections) > len(ind.connections)

    mut_add_neur = NEAT.mutate_add_neuron(ind, cfg)
    # @test len(mut_add_neur.connections) > len(ind.connections)
    # @test len(mut_add_neur.neurons) > len(ind.neurons)
end
