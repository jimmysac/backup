-- Basic UI options
vim.opt.number = true               -- Show line numbers
vim.opt.relativenumber = true       -- Show relative line numbers
vim.opt.cursorline = true            -- Highlight the current line
vim.opt.termguicolors = true         -- Enable 24-bit colors

-- Tabs and indentation
vim.opt.expandtab = true             -- Use spaces instead of tabs
vim.opt.shiftwidth = 2               -- Indent size
vim.opt.tabstop = 2                  -- Number of spaces tabs count for
vim.opt.smartindent = true           -- Enable smart indenting

-- Search
vim.opt.ignorecase = true            -- Case insensitive search
vim.opt.smartcase = true             -- But case sensitive if uppercase letters used
vim.opt.incsearch = true             -- Show search matches as you type

vim.opt.clipboard = "unnamedplus"

vim.cmd [[
  hi Normal guibg=NONE ctermbg=NONE
  hi NormalNC guibg=NONE ctermbg=NONE
]]
