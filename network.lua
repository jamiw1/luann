-- Neural Network implementation with multiple hidden layers
local NeuralNetwork = {}
NeuralNetwork.__index = NeuralNetwork

-- Activation function (sigmoid)
local function sigmoid(x)
    return 1 / (1 + math.exp(-x))
end

-- Derivative of sigmoid
local function sigmoidDerivative(x)
    return x * (1 - x)
end

-- Create a new neural network
function NeuralNetwork.new(inputNodes, hiddenLayers, outputNodes)
    local self = setmetatable({}, NeuralNetwork)
    self.inputNodes = inputNodes
    self.hiddenLayers = hiddenLayers -- Table containing number of nodes in each hidden layer
    self.outputNodes = outputNodes
    self.learningRate = 0.1
    
    -- Initialize weights
    self.weights = {}
    local previousLayer = inputNodes
    for i = 1, #hiddenLayers do
        self.weights[i] = {}
        for j = 1, hiddenLayers[i] do
            self.weights[i][j] = {}
            for k = 1, previousLayer do
                self.weights[i][j][k] = math.random() * 2 - 1
            end
        end
        previousLayer = hiddenLayers[i]
    end
    
    -- Output layer weights
    self.weights[#hiddenLayers + 1] = {}
    for i = 1, outputNodes do
        self.weights[#hiddenLayers + 1][i] = {}
        for j = 1, previousLayer do
            self.weights[#hiddenLayers + 1][i][j] = math.random() * 2 - 1
        end
    end
    
    return self
end

-- Forward propagation
function NeuralNetwork:feedForward(inputs)
    local currentLayer = inputs
    self.layerOutputs = {inputs}
    
    -- Process through hidden layers
    for i = 1, #self.hiddenLayers do
        local nextLayer = {}
        for j = 1, #self.weights[i] do
            local sum = 0
            for k = 1, #currentLayer do
                sum = sum + currentLayer[k] * self.weights[i][j][k]
            end
            nextLayer[j] = sigmoid(sum)
        end
        currentLayer = nextLayer
        self.layerOutputs[i + 1] = currentLayer
    end
    
    -- Process output layer
    local outputs = {}
    for i = 1, self.outputNodes do
        local sum = 0
        for j = 1, #currentLayer do
            sum = sum + currentLayer[j] * self.weights[#self.weights][i][j]
        end
        outputs[i] = sigmoid(sum)
    end
    self.layerOutputs[#self.layerOutputs + 1] = outputs
    
    return outputs
end

-- Train the network
function NeuralNetwork:train(inputs, targets)
    local outputs = self:feedForward(inputs)
    local errors = {}
    
    -- Calculate output layer errors
    errors[#self.weights] = {}
    for i = 1, #outputs do
        errors[#self.weights][i] = (targets[i] - outputs[i]) * sigmoidDerivative(outputs[i])
    end
    
    -- Calculate hidden layer errors
    for i = #self.weights - 1, 1, -1 do
        errors[i] = {}
        for j = 1, #self.weights[i] do
            local error = 0
            for k = 1, #self.weights[i + 1] do
                error = error + errors[i + 1][k] * self.weights[i + 1][k][j]
            end
            errors[i][j] = error * sigmoidDerivative(self.layerOutputs[i + 1][j])
        end
    end
    
    -- Update weights
    for i = 1, #self.weights do
        for j = 1, #self.weights[i] do
            for k = 1, #self.weights[i][j] do
                self.weights[i][j][k] = self.weights[i][j][k] + 
                    self.learningRate * errors[i][j] * self.layerOutputs[i][k]
            end
        end
    end
end

-- Set learning rate
function NeuralNetwork:setLearningRate(rate)
    self.learningRate = rate
end

-- Example usage:

return NeuralNetwork