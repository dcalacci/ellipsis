return {
  -- distraction-free writing, replacing Goyo
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = { width = 90, options = { number = false, relativenumber = false } },
      plugins = { tmux = { enabled = true } },
    },
  },

  -- fugitive and diffview, carried over. LazyVim ships lazygit and gitsigns
  -- already, so these are the extras on top.
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRename", "Gedit" },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    },
  },

  -- treesitter parsers beyond what the lang extras pull in
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        "bash",
        "c",
        "css",
        "java",
        "lua",
        "regex",
        "toml",
      })
    end,
  },
}
