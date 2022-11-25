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
        lazyload = false, -- to show tabufline by default
      },
    },
  },

}
