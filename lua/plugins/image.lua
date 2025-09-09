-- ~/.config/nvim/lua/plugins/image.lua
return {
  "3rd/image.nvim",
  lazy = false, -- load before keymaps
  opts = {
    backend = "kitty",
    integrations = {
      markdown = { enabled = true },
    },
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
  },
  config = function(_, opts)
    local image = require("image")
    image.setup(opts)

    local current_img = nil -- store reference to last rendered image

    vim.keymap.set("n", "<leader>pp", function()
      -- helper: check extension
      local function is_img(p)
        if not p or p == "" then return false end
        p = p:lower()
        return p:match("%.png$") or p:match("%.jpe?g$") or p:match("%.webp$") or p:match("%.gif$")
      end

      -- if already shown → clear it
      if current_img then
        current_img:clear()
        current_img = nil
        return
      end

      -- otherwise, determine path
      local path
      if vim.bo.filetype == "oil" then
        local ok, oil = pcall(require, "oil")
        if not ok then return end
        local entry = oil.get_cursor_entry()
        if not entry then return end
        path = (oil.get_current_dir() or "") .. entry.name
      else
        path = vim.fn.expand("<cfile>")
        if path ~= "" and not path:match("^/") and not path:match("^~") then
          path = (vim.fn.expand("%:p:h") or ".") .. "/" .. path
        end
      end

      if not is_img(path) then
        vim.notify("No image (png/jpg/webp/gif) under cursor / selected", vim.log.levels.WARN)
        return
      end

      -- get terminal size for fullscreen
      local width  = vim.o.columns
      local height = vim.o.lines

      local img = image.from_file(path, {
        x = 0,
        y = 0,
        width = width,
        height = height,
        inline = false,
      })
      if img then
        img:render()
        current_img = img
      end
    end, { desc = "Toggle fullscreen image preview" })

    vim.keymap.set("n", "<leader>pc", function()
      if current_img then
        current_img:clear()
        current_img = nil
      else
        pcall(function() image.clear(true) end)
      end
    end, { desc = "Clear image(s)" })
  end,
}
