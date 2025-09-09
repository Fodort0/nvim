vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>")
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
end, { silent = true })

-- vim.keymap.set("i", "{<CR>", "{<CR>}<Esc>O", { noremap = true, silent = true })

-- Debugger keymaps for nvim-dap
vim.keymap.set("n", "<leader>ll", function()
    require("dap").continue()
end, { desc = "Continue Debugging" })
vim.keymap.set("n", "<leader>al", function()
    require("dap").step_over()
end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>F11", function()
    require("dap").step_into()
end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>F12", function()
    require("dap").step_out()
end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>b", function()
    require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Set Conditional Breakpoint" })
vim.keymap.set("n", "<leader>lp", function()
    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "Set Log Point" })
vim.keymap.set("n", "<leader>dr", function()
    require("dap").repl.open()
end, { desc = "Open REPL" })
vim.keymap.set("n", "<leader>dl", function()
    require("dap").run_last()
end, { desc = "Run Last" })
vim.keymap.set("n", "<A-d>", function()
    require("dap").terminate()
end, { desc = "Terminate Debug Session" })

vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Jump out of pairs quickly: press <C-l> in insert mode
vim.keymap.set("i", "<C-l>", function()
  local col  = vim.fn.col(".")
  local line = vim.fn.getline(".")
  local next = line:sub(col, col)
  if next ~= "" and next:match("[%)%]%}%>'\"`]") then
    return "<Right>"
  end
  return "<C-l>"  -- fallback to default Ctrl-l behavior
end, { expr = true, noremap = true, silent = true })

