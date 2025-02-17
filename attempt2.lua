-- Neural Network implementation in Lua

-- Utility functions
local function sigmoid(x)
    return 1 / (1 + math.exp(-x))
end

local function sigmoid_derivative(x)
    local s = sigmoid(x)
    return s * (1 - s)
end

-- Neural Network class
local NeuralNetwork = {}
NeuralNetwork.__index = NeuralNetwork

function NeuralNetwork.new(input_size, hidden_size, output_size, learning_rate)
    local self = setmetatable({}, NeuralNetwork)
    self.input_size = input_size
    self.hidden_size = hidden_size
    self.output_size = output_size
    self.learning_rate = learning_rate or 0.1

    -- Initialize weights and biases
    self.weights_ih = {}  -- Input to Hidden weights
    self.weights_ho = {}  -- Hidden to Output weights
    self.bias_h = {}     -- Hidden layer bias
    self.bias_o = {}     -- Output layer bias

    -- Initialize input to hidden weights
    for i = 1, hidden_size do
        self.weights_ih[i] = {}
        for j = 1, input_size do
            self.weights_ih[i][j] = math.random() * 2 - 1
        end
        self.bias_h[i] = math.random() * 2 - 1
    end

    -- Initialize hidden to output weights
    for i = 1, output_size do
        self.weights_ho[i] = {}
        for j = 1, hidden_size do
            self.weights_ho[i][j] = math.random() * 2 - 1
        end
        self.bias_o[i] = math.random() * 2 - 1
    end

    return self
end

function NeuralNetwork:forward(inputs)
    -- Hidden layer calculations
    local hidden = {}
    for i = 1, self.hidden_size do
        local sum = self.bias_h[i]
        for j = 1, self.input_size do
            sum = sum + inputs[j] * self.weights_ih[i][j]
        end
        hidden[i] = sigmoid(sum)
    end

    -- Output layer calculations
    local outputs = {}
    for i = 1, self.output_size do
        local sum = self.bias_o[i]
        for j = 1, self.hidden_size do
            sum = sum + hidden[j] * self.weights_ho[i][j]
        end
        outputs[i] = sigmoid(sum)
    end

    return outputs, hidden
end

function NeuralNetwork:train(inputs, targets)
    -- Forward pass
    local outputs, hidden = self:forward(inputs)

    -- Calculate output layer errors
    local output_errors = {}
    local output_gradients = {}
    for i = 1, self.output_size do
        local error = targets[i] - outputs[i]
        output_errors[i] = error
        output_gradients[i] = error * outputs[i] * (1 - outputs[i])
    end

    -- Calculate hidden layer errors
    local hidden_errors = {}
    local hidden_gradients = {}
    for i = 1, self.hidden_size do
        local error = 0
        for j = 1, self.output_size do
            error = error + output_errors[j] * self.weights_ho[j][i]
        end
        hidden_errors[i] = error
        hidden_gradients[i] = error * hidden[i] * (1 - hidden[i])
    end

    -- Update weights and biases
    -- Hidden to output weights
    for i = 1, self.output_size do
        for j = 1, self.hidden_size do
            self.weights_ho[i][j] = self.weights_ho[i][j] + 
                self.learning_rate * output_gradients[i] * hidden[j]
        end
        self.bias_o[i] = self.bias_o[i] + self.learning_rate * output_gradients[i]
    end

    -- Input to hidden weights
    for i = 1, self.hidden_size do
        for j = 1, self.input_size do
            self.weights_ih[i][j] = self.weights_ih[i][j] + 
                self.learning_rate * hidden_gradients[i] * inputs[j]
        end
        self.bias_h[i] = self.bias_h[i] + self.learning_rate * hidden_gradients[i]
    end

    -- Calculate total error
    local total_error = 0
    for i = 1, self.output_size do
        total_error = total_error + math.abs(output_errors[i])
    end
    return total_error
end

-- Example usage:

-- Create a neural network with 2 inputs, 3 hidden neurons, and 1 output
local nn = NeuralNetwork.new(2, 3, 1, 0.1)

-- Training data for XOR function
local training_data = {
    {inputs = {0, 0}, targets = {0}},
    {inputs = {0, 1}, targets = {1}},
    {inputs = {1, 0}, targets = {1}},
    {inputs = {1, 1}, targets = {0}}
}

-- Train the network
for epoch = 1, 10000 do
    local error = 0
    for _, data in ipairs(training_data) do
        error = error + nn:train(data.inputs, data.targets)
    end
    if epoch % 1000 == 0 then
        print("Epoch " .. epoch .. " Error: " .. error)
    end
end

-- Test the network
for _, data in ipairs(training_data) do
    local result = nn:forward(data.inputs)
    print(data.inputs[1] .. " XOR " .. data.inputs[2] .. " = " .. result[1])
end


return NeuralNetwork