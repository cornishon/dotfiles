vim.cmd [[colorscheme slate]]
vim.o.background = "dark"
vim.cmd [[highlight Normal ctermbg=111111 ctermfg=LightGrey]]
vim.cmd [[highlight EndOfBuffer ctermbg=111111 ctermfg=LightGrey]]
vim.cmd [[highlight MatchParen cterm=bold ctermfg=none ctermbg=none]]

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.wrap = false
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.foldmethod = "expr"
vim.o.foldlevel = 99
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

vim.g.completeopt = { "menu", "menuone" , "noselect" }

vim.o.number = true
vim.o.relativenumber = true

vim.o.fortran_free_form = 1
vim.g.fortran_linter = 2

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.sh", "*.bash" },
    command = "!shellcheck %",
})
