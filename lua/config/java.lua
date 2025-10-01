local M = {}

local function run_curr_java_file()
	local buftype = vim.api.nvim_buf_get_option(0, "buftype")

	if buftype == "terminal" then
		-- Close the terminal window if currently in a terminal buffer
		vim.cmd("q")
	else
		-- Get file name in the current buffer
		local file_name = vim.api.nvim_buf_get_name(0)
		local dir = vim.fn.fnamemodify(file_name, ":h")
		local class_name = vim.fn.fnamemodify(file_name, ":t:r")

		-- Add clear before javac + java
		local java_cmd = string.format('clear && javac "%s" && java -cp "%s" %s<CR>', file_name, dir, class_name)
		local term_cmd = vim.api.nvim_replace_termcodes(java_cmd, true, false, true)

		-- Open a fresh terminal split
		local percent_of_win = 0.4
		local curr_win_height = vim.api.nvim_win_get_height(0)
		local term_height = math.floor(curr_win_height * percent_of_win)
		vim.cmd(":belowright " .. term_height .. "split | term")

		-- Start insert in terminal
		vim.cmd("startinsert")

		-- Feed clear + compile + run command
		vim.defer_fn(function()
			vim.api.nvim_feedkeys(term_cmd, "t", false)
		end, 100)
	end
end

-- Key mappings
vim.keymap.set("n", "<A-r>", run_curr_java_file, {
	desc = "Compile & Run .java file via Neovim built-in terminal",
})

-- In terminal mode, map Alt-r to exit the terminal
vim.keymap.set("t", "<A-r>", [[<C-\><C-n><C-w>c]], {
	desc = "Close terminal window",
})

M.run_curr_java_file = run_curr_java_file

return M
