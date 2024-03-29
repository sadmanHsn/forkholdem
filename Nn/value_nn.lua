--- Wraps the calls to the final neural net.
-- @classmod value_nn

require 'torch'
require 'nn'
local arguments = require 'Settings.arguments'
local game_settings = require 'Settings.game_settings'

local ValueNn = torch.class('ValueNn')

--- Constructor. Loads the neural net from disk.
function ValueNn:__init(street, aux)
  local net_file = arguments.model_path
  if game_settings.nl then
    net_file = net_file .. "NoLimit/"
  else
    net_file = net_file .. "Limit/"
  end

  assert(street <= 3)

  -- print(aux)

  if aux then
    assert(street == 1)
    net_file = net_file .. "preflop-aux/"
  else
    if street == 3 then
      net_file = net_file .. "river/"
    elseif street == 2 then
      net_file = net_file .. "turn/"
    elseif street == 1 then
      net_file = net_file .. "flop/"
    end
  end
  net_file = net_file .. arguments.value_net_name

  --0.0 select the correct model cpu/gpu
  if arguments.gpu then
    net_file = net_file .. '_gpu'
  else
    net_file = net_file .. '_cpu'
  end

  -- print(net_file)

  --1.0 load model information
  local model_information = torch.load(net_file .. '.info')

  print('NN information:')
  for k, v in pairs(model_information) do
    print(k, v)
  end
  --import GPU modules only if needed
  if arguments.gpu then
    require 'cunn'
    require 'cutorch'
  end

  --2.0 try to load model
  if pcall(torch.load, net_file .. '.model') then
    self.mlp = torch.load(net_file .. '.model')
    self.mlp:evaluate(true)
    print('NN architecture:')
    print(self.mlp)
  end
end

--- Gives the neural net output for a batch of inputs.
-- @param inputs An NxI tensor containing N instances of neural net inputs.
-- See @{net_builder} for details of each input.
-- @param output An NxO tensor in which to store N sets of neural net outputs.
-- See @{net_builder} for details of each output.
function ValueNn:get_value(inputs, output)
  output:copy(self.mlp:forward(inputs))
end
