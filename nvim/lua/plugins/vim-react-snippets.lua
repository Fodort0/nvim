return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "mlaursen/vim-react-snippets",
  },
  opts = function()
    -- Set the highlight for CmpGhostText
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

    -- Load vim-react-snippets
    require("vim-react-snippets").lazy_load()

    -- Setup nvim-cmp with luasnip and custom configurations
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-space>'] = cmp.mapping.complete(),
      }),
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      },
    })
  end,
  event = "InsertEnter",  -- Lazy load when entering insert mode
}
