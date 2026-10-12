-- Loaded before lazy.nvim starts. LazyVim's own defaults are applied first,
-- so this file only holds the deltas from lvim/config.lua.

local opt = vim.opt

-- treesitter folding. the old config used nvim_treesitter#foldexpr(), which is
-- deprecated; neovim ships a native one now.
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99 -- start with everything open
opt.updatetime = 250

-- prose files wrap at the window, not at a hard column
opt.linebreak = true

-- The old config set vim.g.R_pdfviewer and vim.g.R_objbr_opendf, which were
-- Nvim-R globals. R.nvim reads neither; those settings now live in the
-- plugin spec in lua/plugins/lang.lua.
