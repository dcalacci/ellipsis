-- LazyVim's defaults load first; these are the keymaps carried over from
-- lvim/config.lua. Leader is <space>, same as before.

local map = vim.keymap.set

-- ctrl-s to write, in every mode
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<cr><esc>", { desc = "Save file" })

-- Pane navigation matching tmux.conf's C-h/j/k/l bindings is handled by
-- LazyVim's defaults (<C-h> etc. are already window-move).

-- <leader>A -- asynctasks
map("n", "<leader>Al", "<cmd>AsyncTaskList<cr>", { desc = "List tasks" })
map("n", "<leader>Ar", "<cmd>AsyncTask render<cr>", { desc = "Render Rmd" })
map("n", "<leader>Ac", "<cmd>edit .tasks<cr>", { desc = "Edit .tasks" })

-- <leader>R -- iron REPL
map("n", "<leader>Rr", "<cmd>IronRepl<cr>", { desc = "Start REPL" })
map("n", "<leader>Rf", "<cmd>IronFocus<cr>", { desc = "Focus REPL" })
map("n", "<leader>Rh", "<cmd>IronHide<cr>", { desc = "Hide REPL" })
map("n", "<leader>Rd", "<Plug>(iron-send-line)", { desc = "Send line" })
map("v", "<leader>Rd", "<Plug>(iron-visual-send)", { desc = "Send selection" })

-- <leader>& -- distraction-free writing (zen-mode replaces Goyo)
map("n", "<leader>&", "<cmd>ZenMode<cr>", { desc = "Zen mode" })
