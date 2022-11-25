return {

  ["kyazdani42/nvim-tree.lua"] = {
    override_options = {
      renderer = {
        symlink_destination = false,
      },
      view = {
        mappings = {
          list = {
            { key = "l", action = "edit" },
            { key = "h", action = "close_node" },
          },
        },
      },
    },
  },

  ["NvChad/ui"] = {
    override_options = {
      tabufline = {
        lazyload = false,
      },
    },
  },

  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "custom.plugins.lspconfig"
      require "plugins.configs.lspconfig"
    end,
  },

  ["williamboman/mason.nvim"] = {
    override_options = {
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- shell
        "bash-language-server",
        "shfmt",
        "shellcheck",
      },
    },
  },

}
