local M = {}

local function run_curr_cpp_file()
	local buftype = vim.api.nvim_buf_get_option(0, "buftype")

	if buftype == "terminal" then
		-- Close the terminal window if currently in a terminal buffer
		vim.cmd("q")
	else
		-- Ensure any previous instances of a.exe are terminated
		vim.cmd("!taskkill /f /im a.exe")

		-- Get file name in the current buffer
		local file_name = vim.api.nvim_buf_get_name(0)
		local executable_name = "a.exe"

		-- Get terminal codes for compiling and running the C++ file
		local compile_cmd = vim.api.nvim_replace_termcodes(
			'g++ -O2 -std=c++17 "' .. file_name .. '" -o ' .. executable_name .. " && " .. executable_name .. "<CR>",
			true,
			false,
			true
		)

		-- Determine terminal window split and launch terminal
		local percent_of_win = 0.4
		local curr_win_height = vim.api.nvim_win_get_height(0) -- Current window height
		local term_height = math.floor(curr_win_height * percent_of_win) -- Terminal height
		vim.cmd(":belowright " .. term_height .. "split | term") -- Launch terminal (horizontal split)

		-- Wait for the terminal to open
		vim.cmd("startinsert")
		vim.defer_fn(function()
			-- Press keys to compile and run the C++ command on current file
			vim.api.nvim_feedkeys(compile_cmd, "t", false)
		end, 100) -- Delay to ensure the terminal is ready
	end
end

-- Key mappings
vim.keymap.set("n", "<A-e>", run_curr_cpp_file, {
	desc = "Compile and run .cpp file via Neovim built-in terminal",
})

-- In terminal mode, map Alt-r to exit the terminal
vim.keymap.set("t", "<A-e>", [[<C-\><C-n><C-w>c]], {
	desc = "Close terminal window",
})

M.run_curr_cpp_file = run_curr_cpp_file

return M

