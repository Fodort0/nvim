return {
	"lukas-reineke/indent-blankline.nvim",
	lazy = true,
	main = "ibl",
	opts = {},
	config = function()
		-- Define the colors for the indent guides
		local highlight = {
			"RainbowRed",
		}

		local hooks = require("ibl.hooks")
		-- Create the highlight groups in the highlight setup hook, so they are reset every time the colorscheme changes
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#444457" })
			vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
			vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#E5C07B" })
			vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#E5C07B" })
			vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#D19A66" })
			vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#98C379" })
			vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#C678DD" })
		end)

		vim.g.rainbow_delimiters = { highlight = highlight }
		require("ibl").setup({ scope = { highlight = highlight } })

		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	end,
}

