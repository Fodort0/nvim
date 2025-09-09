return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 9999,
  config = function()
    require("catppuccin").setup({
      flavour = "latte",              -- light variant
      transparent_background = true,
    })
  end,
}
