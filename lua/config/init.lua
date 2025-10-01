local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("config.globals")
require("config.options")
require("config.keymap")
require("config.autocmds")
local opts = {
	defaults = {
		lazy = true,
	},
	install = {
		colorscheme = { "catppuccin" },
	},
	rtp = {
		disabled_plugins = {
			"gzip",
			"matchit",
			"matchparen",
			"netrw",
			"netrwPlugin",
			"tarPlugin",
			"tohtml",
			"tutor",
			"zipPlugin",
		},
	},
	change_detection = {
		notify = true,
	},
}
local status, err = pcall(require, "config.java")
if not status then
	vim.notify("Error loading config.java: " .. err, vim.log.levels.ERROR)
end

local status, err = pcall(require, "config.cpp")
if not status then
	vim.notify("Error loading config.cpp: " .. err, vim.log.levels.ERROR)
end

require("lazy").setup("plugins", opts)
