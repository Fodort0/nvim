local opts = {
	ensure_installed = {
		"efm",
		"bashls",
		"ts_ls",
		"solidity",
		"tailwindcss",
		"pyright",
		"lua_ls",
		"emmet_ls",
		"jsonls",
		"clangd",
	},

	automatic_installation = true,
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = {
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim", -- Add mason-nvim-dap as a dependency
		"mfussenegger/nvim-dap", -- Include nvim-dap for debugging
	},
}

