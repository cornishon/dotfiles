-- First read our docs (completely) then check the example_config repo
local M = {}

M.plugins = require "custom.plugins"

M.mappings = require "custom.mappings"

M.ui = {
  theme = "jellybeans",
  transparency = false,

  changed_themes = {
    jellybeans = {
      base_16 = {
        base00 = "#111111",
      },
      base_30 = {
        black = "#111111",
        darker_black = "#101010",
      },
    },
  },
}

return M
