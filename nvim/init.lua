-- ellipsis neovim config -- LazyVim base.
--
-- Replaces the LunarVim setup that lived in lvim/. LunarVim's last meaningful
-- release was May 2024 and it does not run on neovim 0.11+; this is a port of
-- lvim/config.lua onto LazyVim, which uses the same lazy.nvim underneath.
--
-- Symlinked to ~/.config/nvim by setup.sh.
require("config.lazy")
