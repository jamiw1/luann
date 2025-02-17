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

local function batchMutate(newnetwork, intensity, num)
    local networks = {}
    for i = 1, num do
        networks[i] = newnetwork:mutate(intensity)
    end
    return networks
end

local mynetwork = create_network({2,4,3,1})
print("Before mutation: "..mynetwork:printWeightsAndBiases())

local newnetworks = batchMutate(mynetwork, 0.1, 10)


function love.load()
    love.window.updateMode(0, 0, {resizable = true})
end
function love.draw()
    love.graphics.print("Init Network:\nBefore mutation: "..mynetwork:printWeightsAndBiases())
    for i, newnetwork in ipairs(newnetworks) do
        print("After mutation: "..newnetwork:printWeightsAndBiases())
        love.graphics.print("Network "..i..":\nAfter mutation: "..newnetwork:printWeightsAndBiases(),i * 200,0)
    end
end


--print(mynetwork:pass({3})[1])
--print(mynetwork:pass({4})[1])
--print(mynetwork:pass({5})[1])
--print(mynetwork:pass({6})[1])