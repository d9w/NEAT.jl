export set_inputs, get_outputs, process

function reset(ind::NEATInd)
    for n in ind.neurons
        n.processed = false
    end
end

function set_inputs(ind::NEATInd, inputs::Array{Float64})
    # assume length(inputs) == ind.n_in
    for i in eachindex(inputs)
        ind.neurons[i].output == inputs[i]
        ind.neurons[i].processed = true
    end
end

function get_outputs(ind::NEATInd)
    outputs = zeros(ind.n_out)
    for i in 1:ind.n_out
        outputs[i] = ind.neurons[ind.n_in + i].output
    end
    outputs
end

function activation(x::Float64)
    1 / (1 + exp(-x))
end

function process_neuron(ind::NEATInd, neuron::Int)
    # TODO: recurrent nodes based on genetic order?
    for c in ind.connections
        if c.enabled && c.out_node == neuron
            if !ind.neurons[c.in_node].processed && c.in_node < c.out_node
                process_neuron(ind, c.in_node)
            end
            ind.neurons[neuron].input += ind.neurons[c.in_node].output * c.weight
        end
    end
    # TODO: bias neurons
    ind.neurons[neuron].output = activation(ind.neurons[neuron].input)
    ind.neurons[neuron].processed = true
end

function run_neurons(ind::NEATInd)
    for i in 1:ind.n_hidden
        process_neuron(ind, ind.n_in + ind.n_out + i)
    end
    for i in 1:ind.n_out
        process_neuron(ind, ind.n_in + i)
    end
end

function process(ind::NEATInd, inputs::Array{Float64})
    reset(ind)
    set_inputs(ind, inputs)
    run_neurons(ind)
    get_outputs(ind)
end
