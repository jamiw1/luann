local layer = {}
layer.__index = layer

function layer.new(neurons)
    local self = {}

    self.neurons = neurons

    return setmetatable(self, layer)
end

function layer:pass(inputs)
    local outputs = {}
    for i, neuron in ipairs(self.neurons) do
        outputs[i] = neuron:pass(inputs)
    end
    return outputs
end

function layer:updateLayer(errors, learning_rate)
    local new_errors = {}
    for i, neuron in ipairs(self.neurons) do
        local neuron_error = errors[i]
        local neuron_inputs = neuron.inputs
        neuron:updateNeuron(neuron_error, learning_rate)
        
        -- Calculate the error for the previous layer
        for j, input in ipairs(neuron_inputs) do
            new_errors[j] = (new_errors[j] or 0) + neuron_error * neuron.weights[j]
        end
    end
    return new_errors
end

return layer