local configs = require "nvim-treesitter.configs"

configs.setup {
    ensure_installed = {
        "lua",
        "python",
        "rust",
        "julia",
        "bash",
        "fish",
        "fortran",
    },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
    rainbow = {
        enable = true,
        extended_mode = true,
    },
}

