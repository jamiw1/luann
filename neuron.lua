local neuron = {}
neuron.__index = neuron

local function activation(value)
    --return math.min(math.max(value, 0), math.huge) --ReLU
    return 1/(1+math.exp(-value)) --Sigmoid
end

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
    self.weights = weights -- table of values, #inputs must be equal to #weights

    return setmetatable(self, neuron)
end

function neuron:pass(inputs)
    if #inputs ~= #self.weights then
        error("Number of inputs must be equal to number of weights")
    end
    local total = 0
    for i, input in ipairs(inputs) do
        total = total + (input * self.weights[i])
    end
    return activation(total + self.bias)
end

return neuron