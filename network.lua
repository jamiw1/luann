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

return network