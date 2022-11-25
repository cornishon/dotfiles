local M = {}

M.general = {
  i = {
    ["<C-s>"] = { "<cmd> w <CR>", "save file" },
  },
  n = {
    ["<C-q>"] = { "<cmd> wqall <CR>", "quit nvim" }
  },
}

M.tabufline = {
  n = {
    ["<C-w>"] = {
      function()
        require("nvchad_ui.tabufline").close_buffer()
      end,
      "close buffer",
    },
  }
}

return M
