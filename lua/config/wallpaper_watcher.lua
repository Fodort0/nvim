local M, uv = {}, vim.loop

local cache = vim.fn.expand("~/.config/ml4w/cache/current_wallpaper")
local cache_dir, cache_name = vim.fn.fnamemodify(cache, ":h"), vim.fn.fnamemodify(cache, ":t")

-- helpers -------------------------------------------------------------------
local function read_line()
  local ok, lines = pcall(vim.fn.readfile, cache)
  return ok and lines[1] and vim.trim(lines[1]):lower() or ""
end
local function want(path)   return path:find("light") and "catppuccin-latte" or "nightfox" end

-- robust loader -------------------------------------------------------------
local function load(theme)
  if theme == "catppuccin-latte" then
    local ok, cat = pcall(require, "catppuccin")
    return ok and pcall(cat.load, "latte") or pcall(vim.cmd.colorscheme, theme)
  else
    local ok, fox = pcall(require, "nightfox")
    return ok and pcall(fox.load, "nightfox") or pcall(vim.cmd.colorscheme, "nightfox")
  end
end

-- apply + redraw + lualine refresh -----------------------------------------
local function apply(theme)
  if load(theme) then
    vim.schedule(function()
      pcall(function() require("lualine").refresh() end)   -- refresh status‑line
    end)
    vim.cmd.redraw({ bang = true })
    return true
  end
  return false
end

-- core logic ----------------------------------------------------------------
local poll
local function ensure()
  local theme = want(read_line())
  if theme ~= "" and theme ~= vim.g.colors_name then
    apply(theme)
  end
end
local function kick()
  if poll then return end
  poll = uv.new_fs_poll()
  poll:start(cache, 200, vim.schedule_wrap(function()
    ensure()
    if vim.g.colors_name == want(read_line()) then
      poll:stop(); poll:close(); poll = nil
    end
  end))
end

function M.setup()
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function() ensure(); kick() end,
  })

  uv.new_fs_event():start(cache_dir, {}, vim.schedule_wrap(function(_, n)
    if n == cache_name then kick() end
  end))

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function() vim.defer_fn(kick, 10) end,
  })
end

return M
