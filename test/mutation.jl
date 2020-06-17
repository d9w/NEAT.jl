cfg = get_config("test.yaml")
cfg["innovation_max"] = 5

ind = NEATInd(cfg)

mut_w = mutate_weight(ind)
@test mut_w.weight != ind.weight

mut_en = mutate_enabled(ind)
@test mut_w.enabled != ind.enabled
