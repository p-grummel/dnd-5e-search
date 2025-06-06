local api_request = require("api_request")
local constants = require("constants")
local telescope_buffer = require("telescope_buffer")

local function open_monster_manual()
	api_request.send(constants.ALL_MONSTERS_URL, api_request.list_entry_decoder, function(data)
		telescope_buffer.draw(data, function(entry)
			api_request.send(entry.url, api_request.monster_decoder, function(d)
				print(vim.inspect(d))
			end)
		end)
	end)
end

vim.api.nvim_create_user_command("DnDMonsterManual", function()
	open_monster_manual()
end, {})
