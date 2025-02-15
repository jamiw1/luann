local neuron = require("neuron")
local layer = require("layer")
local network = require("network")

local inputs = {2}
local weights = {{0.5,-0.3,0.7},{0.8,-0.4,0.6}}
local biases = {{1,-0.5,0.2},{0.3}}

local mynetwork = network.new({
    layer.new({neuron.new(1, {0.5}), neuron.new(-.5, {-0.3}), neuron.new(.2, {0.7})}),
    layer.new({neuron.new(.3, {0.8, -0.4, 0.6})})
})
print(mynetwork:pass(inputs)[1])