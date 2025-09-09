local M = {}

local function run_curr_python_file()
	local buftype = vim.api.nvim_buf_get_option(0, "buftype")

	if buftype == "terminal" then
		-- Close the terminal window if currently in a terminal buffer
		vim.cmd("q")
	else
		-- Get file name in the current buffer
		local file_name = vim.api.nvim_buf_get_name(0)

		-- Get terminal codes for running python file
		-- ("i" to enter insert before typing rest of the command)
		local py_cmd = vim.api.nvim_replace_termcodes('python "' .. file_name .. '"<CR>', true, false, true)

		-- Determine terminal window split and launch terminal
		local percent_of_win = 0.4
		local curr_win_height = vim.api.nvim_win_get_height(0) -- Current window height
		local term_height = math.floor(curr_win_height * percent_of_win) -- Terminal height
		vim.cmd(":belowright " .. term_height .. "split | term") -- Launch terminal (horizontal split)

		-- Wait for the terminal to open
		vim.cmd("startinsert")
		vim.defer_fn(function()
			-- Press keys to run python command on current file
			vim.api.nvim_feedkeys(py_cmd, "t", false)
		end, 100) -- Delay to ensure the terminal is ready
	end
end

-- Key mappings
vim.keymap.set("n", "<A-r>", run_curr_python_file, {
	desc = "Run .py file via Neovim built-in terminal",
})

-- In terminal mode, map Alt-r to exit the terminal
vim.keymap.set("t", "<A-r>", [[<C-\><C-n><C-w>c]], {
	desc = "Close terminal window",
})

M.run_curr_python_file = run_curr_python_file

return M

