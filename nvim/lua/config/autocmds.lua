-- LazyVim's defaults load first.

local augroup = vim.api.nvim_create_augroup("ellipsis", { clear = true })

-- Rmd chunk folding, from the commented-out block at the end of the old
-- lvim/config.lua.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "rmd", "quarto" },
  callback = function()
    vim.opt_local.foldmethod = "marker"
    vim.opt_local.foldmarker = "```{,```"
  end,
})

-- Prose: soft wrap and spellcheck.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "markdown", "rmd", "quarto", "tex", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 2
  end,
})
