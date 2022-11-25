local configs = require("nvim-treesitter.configs")

configs.setup {
    ensure_installed = {
        "lua",
        "python",
        "rust",
        "julia",
        "bash",
        "fish",
    },
    highlight = {
        enable = true,
        disable = {
            "fortran",
        },
    },
    indent = {
        enable = true,
    },
    rainbow = {
        enable = true,
        extended_mode = false,
    },
}
