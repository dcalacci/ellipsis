-- Literate / REPL-driven work: iron.nvim for send-to-REPL, jupytext for
-- editing .ipynb as Rmd, asynctasks for `render` and friends.
return {
  {
    "Vigemus/iron.nvim",
    cmd = { "IronRepl", "IronFocus", "IronHide", "IronRestart" },
    keys = {
      { "<leader>R", desc = "+repl" },
    },
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")

      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = { command = { "ipython", "--no-autoindent" } },
            r = { command = { "R", "--no-save" } },
            rmd = { command = { "R", "--no-save" } },
            quarto = { command = { "R", "--no-save" } },
            sh = { command = { "zsh" } },
            zsh = { command = { "zsh" } },
            lua = { command = { "lua" } },
          },
          repl_open_cmd = view.split.vertical.botright(0.4),
        },
        keymaps = {
          send_motion = "<leader>Rc",
          visual_send = "<leader>Rc",
          send_file = "<leader>RF",
          send_line = "<leader>Rl",
          send_until_cursor = "<leader>Ru",
          cr = "<leader>R<cr>",
          interrupt = "<leader>R<space>",
          exit = "<leader>Rq",
          clear = "<leader>Rx",
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      })
    end,
  },

  -- open and write .ipynb files as if they were Rmd, same as the old
  -- vim.g.jupytext_fmt = "Rmd". The plugin builds the format string as
  -- "<output_extension>:<style>", and jupytext only accepts "rmarkdown" as
  -- the format name for .Rmd -- "Rmd:markdown" is rejected.
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      style = "rmarkdown",
      output_extension = "Rmd",
      force_ft = "rmd",
    },
  },

  -- :AsyncTask render etc., driven by a .tasks file in the project root
  { "skywind3000/asyncrun.vim", cmd = { "AsyncRun", "AsyncStop" } },
  {
    "skywind3000/asynctasks.vim",
    cmd = { "AsyncTask", "AsyncTaskList", "AsyncTaskEdit" },
    dependencies = { "skywind3000/asyncrun.vim" },
    init = function()
      vim.g.asyncrun_open = 10
      vim.g.asynctasks_term_pos = "bottom"
      vim.g.asynctasks_term_rows = 12
    end,
  },
}
