return {
  dir = vim.fn.stdpath("config") .. "/lua/config",
  name = "wallpaper_watcher",
  lazy = false,
  priority = 10000,               -- low = load last
  dependencies = { "catppuccin/nvim", "EdenEast/nightfox.nvim" },
  config = function()
    require("config.wallpaper_watcher").setup()
  end,
}
