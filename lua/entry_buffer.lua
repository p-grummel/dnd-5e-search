local display_helper = require("display_helper")

local function config_window(entry)
  local lines = display_helper.display_monster(entry)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

  --TODO: comment back in, made editable for test purposes
  -- vim.api.nvim_buf_set_option(buf, "modifiable", false)
  -- vim.api.nvim_buf_set_option(buf, "readonly", true)

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  vim.cmd("tabnew")

  vim.api.nvim_win_set_buf(0, buf)
  vim.bo[buf].filetype = "markdown"

  vim.api.nvim_buf_set_name(buf, entry.name)

  return buf
end

return {
  open = function(entry)
    config_window(entry)
  end,
}
