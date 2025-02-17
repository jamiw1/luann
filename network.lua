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
    for i, layer in ipairs(self.layers) do
        print("Layer " .. i)
        for j, neuron in ipairs(layer.neurons) do
            print(" Neuron " .. j)
            print("     Bias: " .. neuron.bias)
            for k, weight in ipairs(neuron.weights) do
                print("     Weight " .. k .. ": " .. weight)
            end
        end
    end
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