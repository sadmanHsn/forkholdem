require 'math'
require 'os'
local constants = require "Settings.constants"

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function generate_cards()

	local generatedCards = {}
	local suit, rank
	local index = 1

	local M = {}
	M.suit_table = {'h', 's', 'c', 'd'}
	M.rank_table = {'A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'}

	while index < 10 do
		math.randomseed(os.time())
		suit = M.suit_table[math.floor(math.random(1, 4))]
		rank = M.rank_table[math.floor(math.random(1, 13))]
		card = rank .. suit
		if (has_value(generatedCards, card) == false) then
			generatedCards[index] = card
			index = index + 1
		end
	end

	local out = {}

	out.userCards = generatedCards[1] .. generatedCards[2]
	out.aICards = generatedCards[3] .. generatedCards[4]
	out.flop = generatedCards[5] .. generatedCards[6] .. generatedCards[7]
	out.turn = generatedCards[8]
	out.river = generatedCards[9]

	return out

end

function parse_actions(actions)

	local out = {}
	local actions_remainder = actions

	while actions_remainder ~= '' do

		local parsed_chunk = ''
		if string.starts(actions_remainder, "c") then
		table.insert(out, {action = constants.acpc_actions.ccall})
		parsed_chunk = "c"
		elseif string.starts(actions_remainder, "r") then
		local _
		local raise_amount
		_, _, raise_amount = string.find(actions_remainder, "^r(%d*).*")
		raise_amount = tonumber(raise_amount)
		table.insert(out, {action = constants.acpc_actions.raise, raise_amount = raise_amount})
		parsed_chunk = "r" .. raise_amount
		elseif string.starts(actions_remainder, "f") then
		table.insert(out, {action = constants.acpc_actions.fold})
		parsed_chunk = "f"
		else
		assert(false)
		end    
		
		assert(#parsed_chunk > 0)
		actions_remainder = string.sub(actions_remainder, #parsed_chunk + 1)
	end


	return out
end
  