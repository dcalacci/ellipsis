return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = true,
      dimInactive = true,
      terminalColors = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "kanagawa" },
  },
  -- live hex/rgb/hsl colour swatches, replacing nvim-colorizer.lua
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        names = false,
      },
    },
  },
}
