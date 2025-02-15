local neuron = {}
neuron.__index = neuron


--[[
Neuron code is structured like this:
  weights   +bias activate
 ---------> output

Loops through inputs, multiplies weights respective inputs,
adds up the results, adds bias and activates
]]

function neuron.new(bias, weights)
    local self = {}
    self.bias = bias
    self.weights = weights --

    return setmetatable(self, neuron)
end

