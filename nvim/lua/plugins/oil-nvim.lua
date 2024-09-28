return {
	"stevearc/oil.nvim",
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	config = function()
		require("oil").setup({
			default_file_explorer = true,
		})
	end,
	lazy = false,
}
