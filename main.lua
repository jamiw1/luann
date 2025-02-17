local NeuralNetwork = require("network")

local nn = NeuralNetwork.new(2, {4, 3}, 1)  -- 2 inputs, 2 hidden layers (4 and 3 nodes), 1 output
nn:setLearningRate(0.1)


local trainingData = {
    {{1, 0}, {1}},
    {{0, 1}, {1}},
    {{1, 1}, {0}},
    {{0, 0}, {0}}
}
-- Training
for i=1, 10000 do
    nn:train(trainingData)
    if i % 1000 == 0 then
        print("Epoch: "..i.." Error: "..nn:error({1, 0}, {1}))
    end
end

-- Prediction
local result = nn:feedForward({1, 0})
print(result[1])
local result = nn:feedForward({0, 1})
print(result[1])


return NeuralNetwork