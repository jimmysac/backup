-- Ensure Lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- Lazy.nvim is not installed, so install it
  vim.fn.system({
    "git", "clone", "--depth", "1", "https://github.com/folke/lazy.nvim.git", lazypath
  })
end

-- Prepend Lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Autopairs plugin
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Catppuccin plugin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
        transparent_background = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          treesitter = true,
          lualine = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Telescope plugin
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_config = {
            prompt_position = "top",
          },
          sorting_strategy = "ascending",
        },
      })
    end,
  },

  -- nvim-cmp and its dependencies
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "onsails/lspkind.nvim", -- optional: pretty icons
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },

   {
    "junegunn/goyo.vim",  -- GitHub repo for Goyo
    config = function()
      -- Set the width for distraction-free mode
      vim.cmd("let g:goyo_width = 100")  -- Set the width to 100 columns, adjust as per your preference
      -- Hide line numbers in Goyo
      vim.cmd("let g:goyo_hide_line_numbers = 1")
      -- Hide the status line in Goyo
      vim.cmd("let g:goyo_hide_statusline = 1")
      -- Disable cursorline
      vim.cmd("let g:goyo_cursorline = 0")
      -- Optional: Set a color scheme for Goyo (if you want something different in distraction-free mode)
      -- vim.cmd("colorscheme gruvbox")  -- Uncomment if you want a different colorscheme in Goyo
    end,
  },

})

