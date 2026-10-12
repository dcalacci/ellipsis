-- Language tweaks on top of the LazyVim lang extras.
return {
  -- Python: ruff replaces the old black + flake8 null-ls pair. The old config
  -- ran flake8 with --line_width=88 --extend-ignore=E203, which is what
  -- ruff's defaults at line-length 88 give you.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
      },
      -- Don't set format_on_save here: LazyVim owns it and warns if you do.
      -- The old `lvim.format_on_save = true` is LazyVim's default behaviour;
      -- toggle it per-buffer or globally with :LazyFormatToggle.
    },
  },

  -- R. The old config set vim.g.R_pdfviewer = "open" and
  -- vim.g.R_objbr_opendf = 0, which were Nvim-R globals that R.nvim ignores.
  -- These are the equivalents. The LazyVim lang.r extra already routes PDF
  -- opening through vim.ui.open (`open` on macOS), so pdfviewer stays empty.
  {
    "R-nvim/R.nvim",
    opts = {
      objbr_opendf = false,
      objbr_auto_start = false,
      open_pdf = "open and focus",
      min_editor_width = 80,
      rconsole_width = 80,
    },
  },

  -- markdown-preview is already in the LazyVim lang.markdown extra, bound to
  -- <leader>cp, with a build step that loads the plugin before calling
  -- mkdp#util#install(). Respeccing it here broke that install, so don't.

  -- shaders, carried over from the lvim config
  { "tikhomirov/vim-glsl", ft = "glsl" },
  { "timtro/glslView-nvim", ft = "glsl" },
}
