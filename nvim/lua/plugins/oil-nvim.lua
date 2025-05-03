return {
  "stevearc/oil.nvim",
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      view_options = {
                show_hidden = true
            }
    })

    -- Set Ctrl+C to function as Esc in Oil.nvim buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      
      callback = function()
        vim.keymap.set("n", "<C-c>", "<Esc>", { buffer = true, silent = true })
      end,
    })
  end,
  lazy = false,
}
