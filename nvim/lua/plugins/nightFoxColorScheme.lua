return {
  "EdenEast/nightfox.nvim",
  name = "nightfox",
  lazy = false,
  priority = 9998,                    -- just below catppuccin
  config = function()
    require("nightfox").setup({
      options = { transparent = true },
    })
    -- no :colorscheme call here
  end,
}
