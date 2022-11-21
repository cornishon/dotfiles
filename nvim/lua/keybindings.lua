local keymap = vim.api.nvim_set_keymap

local function nmap(key, command)
    keymap("n", key, command, { noremap = true })
end

-- control+s to save
nmap("<c-s>", ":w<cr>")
nmap("<c-q>", ":wq<cr>")
nmap("Q", "q")

-- split navigation with control+{h,j,k,l}
nmap("<c-h>", "<c-w>h")
nmap("<c-j>", "<c-w>j")
nmap("<c-k>", "<c-w>k")
nmap("<c-l>", "<c-w>l")

-- toggle folds with space
nmap("<space>", "za")  -- toggle a single fold
nmap("<c-space>", "zM")  -- refold everything

-- LSP
nmap("gd", ":lua vim.lsp.buf.definition()<cr>")
nmap("gD", ":lua vim.lsp.buf.declaration()<cr>")
nmap("gi", ":lua vim.lsp.buf.implementation()<cr>")
nmap("gw", ":lua vim.lsp.buf.document_symbol()<cr>")
nmap("gw", ":lua vim.lsp.buf.workspace_symbol()<cr>")
nmap("gr", ":lua vim.lsp.buf.references()<cr>")
nmap("gt", ":lua vim.lsp.buf.type_definition()<cr>")
nmap("K", ":lua vim.lsp.buf.hover()<cr>")
nmap("<c-k>", ":lua vim.lsp.buf.signature_help()<cr>")
nmap("<leader>af", ":lua vim.lsp.buf.code_action()<cr>")
nmap("<leader>rn", ":lua vim.lsp.buf.rename()<cr>")

-- Telescope
nmap("<leader>ff", "<cmd>Telescope find_files<cr>")
nmap("<leader>fg", "<cmd>Telescope live_grep<cr>")
nmap("<leader>fb", "<cmd>Telescope buffers<cr>")
nmap("<leader>fh", "<cmd>Telescope help_tags<cr>")
nmap("<leader>fm", "<cmd>Telescope man_pages<cr>")
