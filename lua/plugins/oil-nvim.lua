return {
  "stevearc/oil.nvim",
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      view_options = { show_hidden = true },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        vim.keymap.set("n", "<C-c>", "<Esc>", { buffer = true, silent = true })
      end,
    })

    -- Open current dir in Nemo with zero shell output
    vim.keymap.set("n", "<leader>o", function()
      local oil = require("oil")
      local dir
      if vim.bo.filetype == "oil" then
        dir = oil.get_current_dir()
      else
        dir = vim.fn.expand("%:p:h")
        if dir == "" then dir = vim.fn.getcwd() end
      end

      vim.loop.spawn("sh", {
        args = { "-c", "( nohup setsid nemo '" .. dir .. "' >/dev/null 2>&1 & ) >/dev/null 2>&1" },
        detached = true,
        stdio = { nil, nil, nil },
      }, function() end)
    end, { desc = "Open current Oil dir in Nemo silently" })
  end,
  lazy = false,
}
