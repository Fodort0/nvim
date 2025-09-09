
return {
  -- Snippet engine (load first so cmp can use it)
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    event = "InsertEnter",
    config = function()
      local ls = require("luasnip")
      -- Your custom math snippets for Markdown/MDX
      local s,i,t = ls.snippet, ls.insert_node, ls.text_node
      ls.add_snippets("markdown", {
        s("ff",  { t("\\frac{"), i(1), t("}{"), i(2), t("}") }),
        s("sq",  { t("\\sqrt{"), i(1), t("}") }),
        s("sum", { t("\\sum_{"), i(1), t("}^{"), i(2), t("}") }),
      })
      ls.add_snippets("mdx", {
        s("ff",  { t("\\frac{"), i(1), t("}{"), i(2), t("}") }),
        s("sq",  { t("\\sqrt{"), i(1), t("}") }),
        s("sum", { t("\\sum_{"), i(1), t("}^{"), i(2), t("}") }),
      })

      -- Optional extra keys that never fight Tab:
      vim.keymap.set({ "i", "s" }, "<C-j>", function()
        if ls.expand_or_jumpable() then ls.expand_or_jump() end
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if ls.jumpable(-1) then ls.jump(-1) end
      end, { silent = true })
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "kdheepak/cmp-latex-symbols",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local ls  = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      local has_words_before = function()
        local unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        if col == 0 then return false end
        local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
        return text:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        snippet = { expand = function(args) ls.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          -- Super Tab
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif ls.expand_or_jumpable() then
              ls.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif ls.jumpable(-1) then
              ls.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        }),
      })

      -- Enable LaTeX math suggestions in Markdown & MDX
      for _, ft in ipairs({ "markdown", "mdx" }) do
        cmp.setup.filetype(ft, {
          sources = cmp.config.sources({
            { name = "latex_symbols" }, -- \alpha, \sum, \to, …
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
          }),
        })
      end
    end,
  },

  -- (Optional) Markdown preview with MathJax
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "mdx" },
    build = function()
      -- clean install to avoid yarn.lock warnings
      vim.fn.system("cd app && npm ci")
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown", "mdx" }
    end,
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  },
}
