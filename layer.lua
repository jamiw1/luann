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

return layer