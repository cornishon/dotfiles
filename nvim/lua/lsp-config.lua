require("mason").setup()

local servers = {
    "sumneko_lua",
    "bashls",
    "fortls",
}

require("mason-lspconfig").setup {
    ensure_installed = servers
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

lspconfig.sumneko_lua.setup {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    -- Neovim globals
                    "vim",
                    "use",
                    -- AwesomeWM globals
                    "awesome",
                    "client",
                    "root",
                    "has_fdo",
                    "freedesktop",
                }
            },
            workspace = {
                library = {
                    -- Make the server aware of Neovim runtime files
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                }
            }
        }
    }
}
