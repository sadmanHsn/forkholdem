--- Handles communication to and from DeepStack using the ACPC protocol.
-- 
-- For details on the ACPC protocol, see 
-- <http://www.computerpokercompetition.org/downloads/documents/protocols/protocol.pdf>.
-- @classmod acpc_game
-- require 'ACPC.network_communication'
require 'RoundSimulation.protocol_to_node'
local arguments = require 'Settings.arguments'
local constants = require "Settings.constants"

--if you want to fake what messages the acpc dealer sends, put them in the following list and uncomment it.
local debug_msg = nil--{"MATCHSTATE:0:99::Kh|/", "MATCHSTATE:0:99:cr200:Kh|/", "MATCHSTATE:0:99:cr200:Kh|/Ks"}

local ACPCGame = torch.class('ACPCGame')

--- Constructor
function ACPCGame:__init()
end

--- Connects to a specified ACPC server which acts as the dealer.
-- 
-- @param server the server that sends states to DeepStack, which responds
-- with actions
-- @param port the port to connect on
-- @see network_communication.connect
-- function ACPCGame:connect(server, port)
--   self.protocol_to_node = ACPCProtocolToNode()

--   if not debug_msg then
--     self.network_communication = ACPCNetworkCommunication()
--     self.network_communication:connect(server, port)
--   end
-- end

--- Receives and parses the next poker situation where DeepStack must act.
-- 
-- Blocks until the server sends a situation where DeepStack acts.
-- @return the parsed state representation of the poker situation (see
-- @{protocol_to_node.parse_state})
-- @return a public tree node for the state (see
-- @{protocol_to_node.parsed_state_to_node})
function ACPCGame:get_next_situation()
  while true do
    local msg = io.read()

    local protocol = ACPCProtocolToNode()

    --1.0 get the message from the dealer
    -- if not debug_msg then
    --   msg = self.network_communication:get_line()
    -- else
    --   msg = table.remove(debug_msg, 1)
    -- end

    -- print("Received acpc dealer message:")
    -- print(msg)

    --2.0 parse the string to our state representation
    local parsed_state = protocol:parse_state(msg)
    
    --3.0 figure out if we should act
    
    --current player to act is us
    if parsed_state.acting_player == parsed_state.position then
      --we should not act since this is an allin situations
      if parsed_state.bet1 == parsed_state.bet2 and parsed_state.bet1 == arguments.stack then
        print("Not our turn - alling")
      --we should act
      else
        print("Our turn")

        self.last_msg = msg
        --create a tree node from the current state
        local node = protocol:parsed_state_to_node(parsed_state)

        return parsed_state, node
      end
    --current player to act is the opponent
    else
      print("Not our turn")
    end
  end
end
