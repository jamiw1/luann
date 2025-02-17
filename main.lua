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

local mynetwork = create_network({2,4,1})
print("Before mutation: "..mynetwork:printWeightsAndBiases())

local newnetwork = mynetwork:mutate(0.4)

function love.draw()
    love.graphics.print("Before mutation: "..mynetwork:printWeightsAndBiases())
    love.graphics.print("After mutation: "..newnetwork:printWeightsAndBiases(),300,0)
end

print("After mutation: "..newnetwork:printWeightsAndBiases())
--print(mynetwork:pass({3})[1])
--print(mynetwork:pass({4})[1])
--print(mynetwork:pass({5})[1])
--print(mynetwork:pass({6})[1])