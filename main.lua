local neuron = require("neuron")
local layer = require("layer")
local network = require("network")

math.randomseed(os.time())

function createNetwork(inputcount, neuroncounts)
    local layers = {}
    local previous_count = inputcount

    for _, count in ipairs(neuroncounts) do
        local neurons = {}
        for i = 1, count do
            local weights = {}
            for j = 1, previous_count do
                table.insert(weights, math.random())
            end
            local bias = math.random()
            table.insert(neurons, neuron.new(bias, weights))
        end
        table.insert(layers, layer.new(neurons))
        previous_count = count
    end

    return network.new(layers)
end

local trainingData = {
    {{0, 0}, {0}},
    {{0, 1}, {1}},
    {{1, 0}, {1}},
    {{1, 1}, {0}}
}

local inputs = {1, 1}
local neuroncounts = {3, 1}
local mynetwork = createNetwork(#inputs, neuroncounts)

for i=1, 10000 do
    mynetwork:train(trainingData, 0.1)
    if i % 1000 == 0 then
        print(mynetwork:error(inputs, {0}))
    end
end

print(mynetwork:pass(inputs)[1])
print(mynetwork:error(inputs, {0.9}))
print(mynetwork:error(inputs, {1.2}))
print(mynetwork:error(inputs, {0.3}))

--print(mynetwork:pass({3})[1])
--print(mynetwork:pass({4})[1])
--print(mynetwork:pass({5})[1])
--print(mynetwork:pass({6})[1])