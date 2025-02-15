local inputs = {2}
local weights = {{0.5,-0.3,0.7},{0.8,-0.4,0.6}}
local biases = {{1,-0.5,0.2},{0.3}}

local function activation(value)
    --return math.min(math.max(value, 0), math.huge)
    return 1/(1+math.exp(-value))
end

local hiddenlayervalues = {}
for i, weight in ipairs(weights[1]) do
    hiddenlayervalues[i] = activation((inputs[1] * weight) + biases[1][i])
    --print(weight, hiddenlayervalues[i])
end

local outputlayervalues = {}
local output

for i, weight in ipairs(weights[2]) do
    outputlayervalues[i] = hiddenlayervalues[i] * weight
end
local total = 0
for i, value in ipairs(outputlayervalues) do
    total = total + value
end
output = activation(total + biases[2][1])
print(output)