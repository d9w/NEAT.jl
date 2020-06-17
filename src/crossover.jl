function crossover(parent1::NEATInd, parent2::NEATInd, cfg::Dict)
    genes = Array([], cfg["innovation_max"])
    for c in parent1.connections
        genes[c.innovation]= push!(genes[c.innovation], c)
    end

    for c in parent2.connections
        genes[c.innovation]= push!(genes[c.innovation], c)
    end

    # TODO
    for i in 1:
        cfg["innovation_max"]
    end


end
