local api_request = require("api_request")
local constants = require("constants")
local telescope_buffer = require("telescope_buffer")

local function open_monster_manual()
  api_request.send(constants.ALL_MONSTERS_URL, telescope_buffer.draw)
end

vim.api.nvim_create_user_command("DnDMonsterManual", function()
  open_monster_manual()
end, {})
