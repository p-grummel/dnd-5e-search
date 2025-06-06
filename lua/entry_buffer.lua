local function generate_lines_from_entry(entry)
	return {
		"# " .. entry.name,
		"_" .. entry.size .. " " .. entry.type .. "_",
	}
end

local function config_window(lines)
	local buf = vim.api.nvim_create_buf(false, true) -- unlisted, scratch
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "readonly", true)

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.6)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local opts = {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	-- Match Telescope-like style
	vim.api.nvim_win_set_option(win, "winhighlight", "Normal:NormalFloat,FloatBorder:TelescopeBorder")

	-- Keymap to close on Escape or q
	local close_table = {
		nowait = true,
		noremap = true,
		silent = true,
		callback = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end,
	}

	vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", close_table)
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "", close_table)
	vim.api.nvim_buf_set_keymap(buf, "v", "<Esc>", "", close_table)
	vim.api.nvim_buf_set_keymap(buf, "v", "q", "", close_table)

	return buf, win
end

return {

	open = function(entry)
		local lines = generate_lines_from_entry(entry)
		config_window(lines)
	end,
}
