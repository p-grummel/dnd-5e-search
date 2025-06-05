local Job = require("plenary.job")
local constants = require("constants")

return {
	send = function(prompt, callback)
		Job:new({
			command = "curl",
			args = { "--silent", constants.BASE_URL .. "monsters/?name=" .. prompt },
			on_exit = function(j, return_val)
				--TODO: Error handling
				local output_string = table.concat(j:result(), "\n")
				vim.schedule(function()
					local json = vim.json.decode(output_string).results
					callback(json)
				end)
			end,
		}):start()
	end,
}
