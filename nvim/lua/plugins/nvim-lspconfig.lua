local on_attach = require("util.lsp").on_attach
local diagnostic_signs = require("util.lsp").diagnostic_signs

local config = function()
	require("neoconf").setup({})
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local lspconfig = require("lspconfig")
	local dap = require("dap") -- Require nvim-dap for debugger setup
	vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
	vim.fn.sign_define("DapBreakpointCondition", { text = "🔵", texthl = "", linehl = "", numhl = "" })
	vim.fn.sign_define("DapBreakpointRejected", { text = "⚠️", texthl = "", linehl = "", numhl = "" })
	vim.fn.sign_define("DapLogPoint", { text = "🟢", texthl = "", linehl = "", numhl = "" })
	for type, icon in pairs(diagnostic_signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	local capabilities = cmp_nvim_lsp.default_capabilities()
	local prettier = {
		formatCommand = "prettier --stdin-filepath ${INPUT}",
		formatStdin = true,
	}
	-- LSP configurations (keep your existing configurations here)
	-- lua, json, python, typescript, etc.

	-- C/C++
	lspconfig.clangd.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = {
			"clangd",
			"--offset-encoding=utf-16",
		},
	})
	-- Add tsserver setup here
	lspconfig.tsserver.setup({
		on_attach = function(client, bufnr)
			-- Disable tsserver's formatting capability to avoid conflicts with efm or prettier
			client.server_capabilities.documentFormattingProvider = false
			-- Call your custom on_attach function
			on_attach(client, bufnr)
		end,
		capabilities = capabilities,
		filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	})

	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			-- Use Mason's dynamic path for codelldb
			command = "C:\\Users\\ftama\\AppData\\Local\\nvim-data\\mason\\bin\\codelldb.cmd",
			args = { "--port", "${port}" },
		},
	}

	-- Configuration for C++ debugging with codelldb
	dap.configurations.cpp = {
		{
			name = "Launch C++ with codelldb",
			type = "codelldb",
			request = "launch",
			program = function()
				-- Get the current workspace folder and executable name dynamically
				local workspace = vim.fn.getcwd() -- Get the current working directory (project root)
				local filename = vim.fn.expand("%:t:r") .. ".exe" -- Get the current file's name without extension and add .exe
				return workspace .. "\\" .. filename -- Construct the path dynamically
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			externalConsole = true, -- Change to true i you need to use an external terminal
		},
	}
	require("dap").set_log_level("DEBUG")
	-- Additional LSP and formatter/linters configurations
	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")
	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")
	local eslint = require("efmls-configs.linters.eslint")
	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local fixjson = require("efmls-configs.formatters.fixjson")
	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")
	local hadolint = require("efmls-configs.linters.hadolint")
	local solhint = require("efmls-configs.linters.solhint")
	local cpplint = require("efmls-configs.linters.cpplint")
	local clangformat = require("efmls-configs.formatters.clang_format")

	-- EFM configurations
	lspconfig.efm.setup({
		filetypes = {
			"lua",
			"python",
			"json",
			"jsonc",
			"sh",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"svelte",
			"vue",
			"markdown",
			"docker",
			"solidity",
			"html",
			"css",
		},
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
			hover = true,
			documentSymbol = true,
			codeAction = true,
			completion = true,
		},
		settings = {
			languages = {
				lua = { luacheck, stylua },
				python = { flake8, black },
				typescript = { prettier },
				json = { eslint, fixjson },
				jsonc = { eslint, fixjson },
				sh = { shellcheck, shfmt },
				javascript = { eslint, prettier_d },
				javascriptreact = { prettier},
				typescriptreact = { prettier },
				svelte = { prettier},
				vue = { prettier},
				markdown = { prettier},
				docker = { prettier },
				solidity = { solhint },
				html = { prettier },
				css = { prettier },
			},
		},
	})
end

return {
	"neovim/nvim-lspconfig",
	config = config,
	lazy = false,
	dependencies = {
		"windwp/nvim-autopairs",
		"williamboman/mason.nvim",
		"creativenull/efmls-configs-nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"mfussenegger/nvim-dap", -- Ensure nvim-dap is a dependency
		"jay-babu/mason-nvim-dap.nvim", -- Ensure mason-nvim-dap is included
	},
}

