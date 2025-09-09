local opt = vim.opt

-- Tab / Indentation
opt.tabstop = 4 
opt.shiftwidth = 4 
opt.softtabstop =4
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- Appearance
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.colorcolumn = "100"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.scrolloff = 10
opt.completeopt = "menuone,noinsert,noselect"

-- Behaviour
opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.autochdir = false
opt.iskeyword:append("-")
opt.mouse:append("a")
opt.clipboard:append("unnamedplus")
opt.modifiable = true
opt.guicursor = { "a:ver25" }
opt.encoding = "UTF-8"
opt.showmode = false

-- Core indent setup
vim.cmd [[filetype plugin indent on]]
vim.opt.autoindent = true
vim.opt.cindent = true
-- Keep braces flush but match opening indent:
vim.opt.cinoptions = "{0,}0"
vim.opt.cinoptions:prepend("m1")
-- OR to indent closing brace by one level (adjust shiftwidth lines inward):
-- vim.opt.cinoptions:append("}1s")
