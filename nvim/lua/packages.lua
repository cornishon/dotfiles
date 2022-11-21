require("packer").startup(function()
    use "wbthomason/packer.nvim"

    use "Pocco81/autosave.nvim"

    use {
        "nvim-treesitter/nvim-treesitter",
        requires = { "p00f/nvim-ts-rainbow" },
        run = function()
            local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
            ts_update()
        end
    }

    use {
        "goolord/alpha-nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("alpha").setup(require"alpha.themes.startify".config)
            vim.api.nvim_set_keymap(
                "n", "<c-n>", ":Alpha<CR>", { noremap = true }
            )
        end
    }

    use {
        "williamboman/mason.nvim",
        requires = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
        }
    }

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        }
    }

    use "nvim-lua/popup.nvim"

    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-tree/nvim-web-devicons",
            "nvim-lua/plenary.nvim",
        }
    }

    use {
        "nvim-tree/nvim-tree.lua",
        requires = { "nvim-tree/nvim-web-devicons" },
        tag = "nightly",
    }
end)
