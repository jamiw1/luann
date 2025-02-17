local neuron = require("neuron")
local layer = require("layer")
local network = require("network")

local inputs = {0.5, 0.3}

local function create_network(network_shape)
    local layers = {}
    for i = 1, #network_shape - 1 do
        local neurons = {}
        local num_inputs = i == 1 and network_shape[1] or network_shape[i]
        for j = 1, network_shape[i + 1] do
            local weights = {}
            for k = 1, num_inputs do
                weights[k] = math.random() * 2 - 1
            end
            neurons[j] = neuron.new(math.random() * 2 - 1, weights)
        end
        layers[i] = layer.new(neurons)
    end
    return network.new(layers)
end

local mynetwork = create_network({2,4,1}) --[[network.new({
    layer.new({neuron.new(1, {0.5}), neuron.new(-.5, {-0.3}), neuron.new(.2, {0.7})}),
    layer.new({neuron.new(.3, {0.8, -0.4, 0.6})})
})]]
print(mynetwork:pass(inputs)[1])
print(mynetwork:error(inputs, {0.64}))
print(mynetwork:error(inputs, {1.2}))
print(mynetwork:error(inputs, {0.3}))

local newnetwork = mynetwork:mutate(0.1)

function love.draw()
    -- In versions prior to 11.0, color component values are (0, 102, 102)
    love.graphics.print("Before mutation: "..mynetwork:printWeightsAndBiases())
    love.graphics.print("After mutation: "..newnetwork:printWeightsAndBiases(),300,0)
end

--print(mynetwork:pass({3})[1])
--print(mynetwork:pass({4})[1])
--print(mynetwork:pass({5})[1])
--print(mynetwork:pass({6})[1])