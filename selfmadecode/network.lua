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

function network:train(trainingData, learning_rate)
    for _, data in ipairs(trainingData) do
        local inputs, expected = data[1], data[2]
        local outputs = self:pass(inputs)
        
        -- Calculate output layer error
        local errors = {}
        for i, output in ipairs(outputs) do
            errors[i] = output - expected[i]
        end

        -- Update each layer starting from the output layer
        for i = #self.layers, 1, -1 do
            local layer = self.layers[i]
            errors = layer:updateLayer(errors, learning_rate)
        end
    end
end

return network