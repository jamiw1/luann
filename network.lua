local network = {}
network.__index = network

function network.new(layers)
    local self = {}
    self.layers = layers
    return setmetatable(self, network)
end

function network:pass(inputs)
    local outputs = inputs
    for i, layer in ipairs(self.layers) do
        outputs = layer:pass(outputs)
    end
    return outputs
end

function network:error(inputs, expected)
    local outputs = self:pass(inputs)
    local error = 0
    for i, output in ipairs(outputs) do
        error = error + (output - expected[i])^2
    end
    return error
end

function network:printWeightsAndBiases()
    local endingstring = ""
    for i, layer in ipairs(self.layers) do
        endingstring = endingstring.."Layer " .. i .. "\n"
        for j, neuron in ipairs(layer.neurons) do
            endingstring = endingstring.."  Neuron " .. j .. "\n"
            endingstring = endingstring.."      Bias: " .. neuron.bias .. "\n"
            for k, weight in ipairs(neuron.weights) do
                endingstring = endingstring.."     Weight " .. k .. ": " .. weight .. "\n"
            end
        end
    end
    return endingstring
end

function network:mutate(intensity)
    local newNetwork = network.new(self.layers)
    for _, layer in ipairs(newNetwork.layers) do
        for _, neuron in ipairs(layer.neurons) do
            for i = 1, #neuron.weights do
                neuron.weights[i] = neuron.weights[i] + (math.random() * 2 - 1) * intensity
            end
            neuron.bias = neuron.bias + (math.random() * 2 - 1) * intensity
        end
    end
    return newNetwork
end

return network