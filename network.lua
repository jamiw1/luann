local network = {}
network.__index = network

math.randomseed(os.time())

function network.new(layers)
    local self = setmetatable({}, network)
    self.layers = layers
    return self
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

function network.mutate(self, intensity)
    local newNetwork = network.new(self.layers)
    for i = 1, #newNetwork.layers do
        for k = 1, #newNetwork.layers[i].neurons do
            for j = 1, #newNetwork.layers[i].neurons[k].weights do
                newNetwork.layers[i].neurons[k].weights[j] = self.layers[i].neurons[k].weights[j] + (math.random() * 2) * intensity
            end
            newNetwork.layers[i].neurons[k].bias = self.layers[i].neurons[k].bias + (math.random() * 2 - 1) * intensity
        end
    end
    return newNetwork
end

return network