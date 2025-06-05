return {
	open_floating_window = function(lines)
		local buf = vim.api.nvim_create_buf(false, true) -- unlisted, scratch
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

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

		-- Keymap to close on Escape
		vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
			nowait = true,
			noremap = true,
			silent = true,
			callback = function()
				if vim.api.nvim_win_is_valid(win) then
					vim.api.nvim_win_close(win, true)
				end
			end,
		})

		return buf, win
	end,
}
