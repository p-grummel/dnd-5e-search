local Job = require("plenary.job")
local constants = require("constants")

return {
	send = function(prompt, decoder, callback)
		print(constants.BASE_URL .. prompt)
		Job:new({
			command = "curl",
			args = { "--silent", constants.BASE_URL .. prompt },
			on_exit = function(j, return_val)
				--TODO: Error handling
				local json_string = table.concat(j:result(), "\n")
				vim.schedule(function()
					local json = decoder(json_string)
					callback(json)
				end)
			end,
		}):start()
	end,

	list_entry_decoder = function(json_string)
		local function sort_by_name(entry_1, entry_2)
			return entry_1.name < entry_2.name
		end
		local json = vim.json.decode(json_string).results
		table.sort(json, sort_by_name)
		return json
	end,

	monster_decoder = function(json_string)
		return vim.json.decode(json_string)
	end,
}
