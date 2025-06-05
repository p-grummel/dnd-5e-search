local Job = require("plenary.job")
local constants = require("constants")

local function sort_by_name(entry_1, entry_2)
	return entry_1.name < entry_2.name
end

return {
	send_list_request = function(prompt, callback)
		Job:new({
			command = "curl",
			args = { "--silent", constants.BASE_URL .. prompt },
			on_exit = function(j, return_val)
				--TODO: Error handling
				local output_string = table.concat(j:result(), "\n")
				vim.schedule(function()
					local json = vim.json.decode(output_string).results
					table.sort(json, sort_by_name)
					callback(json)
				end)
			end,
		}):start()
	end,
}
