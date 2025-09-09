local on_attach = require("util.lsp").on_attach
local diagnostic_signs = require("util.lsp").diagnostic_signs

local config = function()
	require("neoconf").setup({})
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local lspconfig = require("lspconfig")
	local dap = require("dap") -- Require nvim-dap for debugger setup

	-- DAP signs
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

	-- =====================
	-- LSP CONFIGURATIONS
	-- =====================

	-- Tailwind CSS
	lspconfig.tailwindcss.setup({
		on_attach = on_attach,
		capabilities = capabilities,
		filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue" },
		settings = {
			tailwindCSS = {
				classAttributes = { "class", "className", "classList", "ngClass" },
				lint = {
					cssConflict = "warning",
					invalidApply = "error",
					invalidScreen = "error",
					invalidVariant = "error",
					invalidConfigPath = "error",
				},
				experimental = {
					classRegex = {
						{
							"tw`([^`]*)",
							'(?:\\s+|^|;|,|\\()className\\s*=\\s*"([^"]*)"',
							"(?:\\s+|^|;|,|\\()className\\s*=\\s*'([^']*)'",
						},
					},
				},
			},
		},
	})

	-- C/C++
	lspconfig.clangd.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = {
			"clangd",
			"--offset-encoding=utf-16",
		},
	})

	-- TypeScript / JavaScript
	lspconfig.ts_ls.setup({
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			on_attach(client, bufnr)
		end,
		capabilities = capabilities,
		filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	})

	-- =====================
	-- Helpers: Mason paths (no mason-registry needed)
	-- =====================
	local function mason_pkg_path(name)
		local p = vim.fn.stdpath("data") .. "/mason/packages/" .. name
		return (vim.fn.isdirectory(p) == 1) and p or nil
	end
	local function mason_bin(name)
		local p = vim.fn.stdpath("data") .. "/mason/bin/" .. name
		return (vim.fn.executable(p) == 1) and p or name
	end

	-- =====================
	-- DAP: CodeLLDB for C/C++ (Linux)
	-- =====================
	local codelldb_cmd = mason_bin("codelldb")
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = codelldb_cmd,
			args = { "--port", "${port}" },
		},
	}

	dap.configurations.cpp = {
		{
			name = "Launch C++ with codelldb",
			type = "codelldb",
			request = "launch",
			program = function()
				-- Ask for the program to run; safer on Linux than guessing
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			externalConsole = false,
		},
	}
	dap.configurations.c = dap.configurations.cpp
	require("dap").set_log_level("DEBUG")

	-- =====================
	-- EFM: Linters/Formatters
	-- =====================
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
	-- override clang-format with your custom style
	local clangformat = {
		formatCommand = "clang-format --style='{BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never}'",
		formatStdin = true,
	}
	-- OPTIONAL: Java formatting via EFM (needs `google-java-format`)
	local google_java_format = {
		formatCommand = "google-java-format -",
		formatStdin = true,
	}

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
            "c",
            "cpp",
			"java", -- enable if you want EFM formatting for Java
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
				javascriptreact = { prettier },
				typescriptreact = { prettier },
				svelte = { prettier },
				vue = { prettier },
				markdown = { prettier },
				docker = { prettier },
				solidity = { solhint },
				html = { prettier },
				css = { clangformat },
                c = { clangformat },
                cpp = { clangformat },
				java = { google_java_format }, -- comment out if you prefer jdtls formatting only
			},
		},
	})

	-- =====================
	-- JAVA (JDTLS + DAP + TESTS) — Linux
	-- =====================
	local ok_jdtls, jdtls = pcall(require, "jdtls")
	if not ok_jdtls then
		vim.notify("[java] nvim-jdtls not found (add 'mfussenegger/nvim-jdtls').", vim.log.levels.ERROR)
		return
	end

	local jdtls_root = mason_pkg_path("jdtls")
	if not jdtls_root then
		vim.notify("[java] Mason package 'jdtls' not found. Run :MasonInstall jdtls", vim.log.levels.ERROR)
		return
	end

	-- Launcher JAR & config dir (Linux)
	local launcher_jar = vim.fn.glob(jdtls_root .. "/plugins/org.eclipse.equinox.launcher_*.jar")
	if launcher_jar == "" then
		vim.notify("[java] Equinox launcher JAR not found under " .. jdtls_root .. "/plugins", vim.log.levels.ERROR)
		return
	end
	local config_dir = jdtls_root .. "/config_linux"
	if vim.fn.isdirectory(config_dir) == 0 then
		vim.notify("[java] JDTLS Linux config dir missing: " .. config_dir, vim.log.levels.ERROR)
		return
	end

	-- Optional debug/test bundles
	local bundles = {}
	local dbg_root = mason_pkg_path("java-debug-adapter")
	if dbg_root then
		local dbg = vim.fn.glob(dbg_root .. "/extension/server/com.microsoft.java.debug.plugin-*.jar")
		if dbg ~= "" then table.insert(bundles, dbg) end
	end
	local test_root = mason_pkg_path("java-test")
	if test_root then
		local test_jars = vim.fn.glob(test_root .. "/extension/server/*.jar")
		if test_jars ~= "" then
			for _, j in ipairs(vim.split(test_jars, "\n")) do
				if j ~= "" then table.insert(bundles, j) end
			end
		end
	end

	-- Root / workspace
	local util = require("lspconfig.util")
	local root_dir = util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle")(vim.fn.getcwd()) or vim.fn.getcwd()
	local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
	local workspace_dir = vim.fn.stdpath("data") .. "/jdtls_workspaces/" .. project_name

	local java_capabilities = cmp_nvim_lsp.default_capabilities()
	local function on_attach_java(client, bufnr)
		pcall(function() on_attach(client, bufnr) end)
		pcall(function() jdtls.setup_dap({ hotcodereplace = "auto" }) end)
		pcall(function() jdtls.setup.add_commands() end)

		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end
		map("n", "<leader>oi", jdtls.organize_imports, "Java: Organize Imports")
		map("n", "<leader>ev", jdtls.extract_variable, "Java: Extract Variable")
		map("v", "<leader>em", jdtls.extract_method,   "Java: Extract Method")
		map("n", "<leader>tc", function() jdtls.test_class() end, "Java: Test Class")
		map("n", "<leader>tm", function() jdtls.test_nearest_method() end, "Java: Test Method")
	end

	local cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens", "java.base/java.util=ALL-UNNAMED",
		"--add-opens", "java.base/java.lang=ALL-UNNAMED",
		"-jar", launcher_jar,
		"-configuration", config_dir,
		"-data", workspace_dir,
	}

	local settings = {
		java = {
			format = {
				enabled = true,
				settings = {
					url = vim.fn.filereadable(vim.fn.getcwd() .. "/.google-java-format.xml") == 1
						and (vim.fn.getcwd() .. "/.google-java-format.xml")
						or nil,
					profile = "GoogleStyle",
				},
			},
			configuration = {
				runtimes = {
					-- { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk" },
					-- { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk" },
				},
			},
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },
			signatureHelp = { enabled = true },
			sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
			completion = { favoriteStaticMembers = { "org.junit.Assert.*", "org.hamcrest.Matchers.*" } },
			contentProvider = { preferred = "fernflower" },
		},
	}

	local function start_jdtls()
		jdtls.start_or_attach({
			cmd = cmd,
			root_dir = root_dir,
			capabilities = java_capabilities,
			settings = settings,
			init_options = { bundles = bundles },
			on_attach = on_attach_java,
		})
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "java",
		callback = start_jdtls,
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
		"mfussenegger/nvim-jdtls", -- <-- Java LSP extras
	},
}
