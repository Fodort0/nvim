-- lua/plugins/lualine.lua
local function config()
  -- you like these Gruvbox colours for the bar text – keep them
  local theme = require("lualine.themes.gruvbox")
  theme.normal.c.bg  = nil
  theme.insert.c.bg  = nil
  theme.visual.c.bg  = nil
  theme.replace.c.bg = nil
  theme.command.c.bg = nil

  require("lualine").setup({
    options = {
      theme            = "auto",            -- pick from current scheme
      icons_enabled    = true,
      component_separators = { "", "" },
      section_separators   = { "", "" },
      refresh = { statusline = 1000 },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { "filename" },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  })
end

return {
  "nvim-lualine/lualine.nvim",
  event  = "ColorScheme",      -- load only after the first scheme
  config = config,
}
