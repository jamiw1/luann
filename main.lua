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

function sortingFunction(network1, network2) 
    return network1[2] < network2[2]
end
function linear_scale(source_value, source_min, source_max, target_min, target_max)
    return (source_value - source_min) * (target_max - target_min) / (source_max - source_min) + target_min
end

local function mutateBestNetworks(networkfitnesses --[[ {{network, fitness}} ]], gradient)
    -- gradient is the top percent that reproduce, which is then scaled with the lowest network getting 0
    networkfitnesses = table.sort(networkfitnesses, sortingFunction)
    for i, networkfit in ipairs(networkfitnesses) do -- kill lowest percent of networks
        if i/#networkfitnesses < gradient then
            networkfitnesses[i] = nil
        end
    end
    local newNetworks = {}
    local networkCount = #networkfitnesses
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