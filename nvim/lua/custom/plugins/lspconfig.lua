local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "sumneko_lua", "bashls", "fortls" }

local settings = {}

settings.sumneko_lua = {
  Lua = {
    diagnostics = {
      globals = {
        -- neovim
        "vim",

        -- awesome
        "awesome",
        "client",
        "root",
        "has_fdo",
        "freedesktop",

      },
    },
    workspace = {
      library = {
        [vim.fn.expand "$VIMRUNTIME/lua"] = true,
        [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
      },
      maxPreload = 100000,
      preloadFileSize = 10000,
    },
  },
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = settings[lsp],
  }
end

