local o = vim.opt

vim.cmd [[colorscheme slate]]
vim.cmd [[highlight Normal ctermbg=111111]]
vim.cmd [[highlight MatchParen cterm=bold ctermfg=none ctermbg=none]]

o.tabstop = 4
o.shiftwidth = 4
o.autoindent = true
o.expandtab = true
o.wrap = false

o.foldmethod = "expr"
o.foldlevel = 99
o.foldexpr = "nvim_treesitter#foldexpr()"

o.completeopt = { "menu", "menuone" , "noselect" }

o.number = true
o.relativenumber = true
