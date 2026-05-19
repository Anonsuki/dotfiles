vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.o.background = "dark"

-- Cursor and selection clarity
vim.opt.cursorline = true
vim.opt.cursorcolumn = false

-- Status Line
vim.opt.laststatus = 3

-- Prevent accidental low-contrast text
vim.opt.pumblend = 0
vim.opt.winblend = 0

-- Highlight Parentheses without Rainbow Delimiters
vim.api.nvim_set_hl(0, "MatchParen", { bg = "#5B5E5F", fg = "#d4be98", bold = true })

-- Mouse Support
vim.opt.mouse = "a"

require("config.lazy")
