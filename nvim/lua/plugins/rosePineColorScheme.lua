return {
	"rose-pine/neovim",
	lazy = false, -- ensure it's loaded without lazy loading
	priority = 9999, -- high priority to load early
	config = function()
		-- Setup the Rose Pine theme before applying the colorscheme
		require("rose-pine").setup({
			variant = "moon", -- auto, main, moon, or dawn
			dark_variant = "moon", -- main, moon, or dawn
			dim_inactive_windows = false,
			extend_background_behind_borders = true,

			enable = {
				terminal = true,
				legacy_highlights = true,
				migrations = true,
			},

			styles = {
				bold = true,
				italic = true,
				transparency = false,
			},

			groups = {
				border = "muted",
				link = "iris",
				panel = "surface",

				error = "love",
				hint = "iris",
				info = "foam",
				note = "pine",
				todo = "rose",
				warn = "gold",

				git_add = "foam",
				git_change = "rose",
				git_delete = "love",
				git_dirty = "rose",
				git_ignore = "muted",
				git_merge = "iris",
				git_rename = "pine",
				git_stage = "iris",
				git_text = "rose",
				git_untracked = "subtle",

				h1 = "iris",
				h2 = "foam",
				h3 = "rose",
				h4 = "gold",
				h5 = "pine",
				h6 = "foam",
			},

			pallete = {
				moon = {
				     base = '#29233a',
				     overlay = '#363738',
				},
			},

			highlight_groups = {
				-- Comment = { fg = "foam" },
				-- VertSplit = { fg = "muted", bg = "muted" },
			},

			before_highlight = function(group, highlight, palette)
				-- Disable all undercurls
				-- if highlight.undercurl then
				--     highlight.undercurl = false
				-- end
				--
				-- Change palette colour
				-- if highlight.fg == palette.pine then
				--     highlight.fg = palette.foam
				-- end
			end,
		})

		-- Apply the colorscheme
		vim.cmd("colorscheme rose-pine")
	end,
}

