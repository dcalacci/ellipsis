--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "kanagawa"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

vim.g.R_pdfviewer = "open"
vim.g.R_objbr_opendf = 0
-- vim.g.R_external_term = "IronFocus"
vim.g.jupytext_fmt = 'Rmd'
-- vim.cmd [[ let g:jupytext_filetype_map = {'Rmd': 'rmd'}]]


-- Copilot
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

local cmp = require "cmp"
lvim.builtin.cmp.sources = {
  { name = "nvim_lsp" },
  { name = "cmp_tabnine", max_item_count = 3 },
  { name = "buffer", max_item_count = 5, keyword_length = 5 },
  { name = "path", max_item_count = 5 },
  { name = "luasnip", max_item_count = 3 },
  { name = "nvim_lua" },
  { name = "calc" },
  { name = "emoji" },
  { name = "treesitter" },
  { name = "crates" },
  { name = "orgmode" },
}
-- lvim.builtin.cmp.documentation.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
lvim.builtin.cmp.experimental = {
  ghost_text = false,
  native_menu = false,
  custom_menu = true,
}
-- lvim.builtin.cmp.formatting.kind_icons = require("user.lsp_kind").symbols()
lvim.builtin.cmp.formatting.source_names = {
  buffer = "(Buffer)",
  nvim_lsp = "(LSP)",
  luasnip = "(Snip)",
  treesitter = "",
  nvim_lua = "(NvLua)",
  spell = "暈",
  emoji = "",
  path = "",
  calc = "",
  cmp_tabnine = "ﮧ",
  ["vim-dadbod-completion"] = "𝓐",
}
lvim.keys.insert_mode["<c-h>"] = { [[copilot#Accept("\<CR>")]], { expr = true, script = true } }
local cmp = require "cmp"
lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(tab, { "i", "c" })
lvim.builtin.cmp.mapping["<S-Tab>"] = cmp.mapping(shift_tab, { "i", "c" })


-- lvim.builtin.cmp.mapping["<C-e>"] = function(fallback)
--   -- vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
--   -- imap <silent><script><expr> <C-e> copilot#Accept('\<CR>')
--   cmp.mapping.abort()
--   local copilot_keys = vim.fn["copilot#Accept"]()
--   if copilot_keys ~= "" then
--     vim.api.nvim_feedkeys(copilot_keys, "i", true)
--   else
--     fallback()
--   end
-- end
-- cmp.setup({ experimental = { ghost_text = false } })


-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
-- }

vim.o.updatetime = 250
-- vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
-- vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["r"] = { "<cmd>call feedkeys('\\')<CR>", "Work with R" }
lvim.builtin.which_key.vmappings["s"] = { "<Plug>REDSendSelection", "Send to Nvim-R" }
lvim.builtin.which_key.vmappings["d"] = { "<Plug>(iron-visual-send)", "Send visual to REPL" }

lvim.builtin.which_key.mappings["A"] = {
  name = "+Tasks",
  l = { "<cmd>AsyncTaskList<cr>", "List" },
  r = { "<cmd>AsyncTask render<cr>", "Render Rmd" },
  c = { "<cmd>e .tasks<cr>", "Edit" },
}

lvim.builtin.which_key.mappings["R"] = {
  name = "+REPL",
  r = { "<cmd>IronRepl<CR>", "Start REPL" },
  d = { "<Plug>(iron-send-line)", "Send line" },
  f = { "<cmd>IronFocus<CR>", "Refocus" },
}

lvim.builtin.which_key.mappings["&"] = { "<cmd>Goyo<CR>", "Goyo Mode" }


-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
-- lvim.builtin.dashboard.active = false
-- lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
-- lvim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "svelte",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheReset` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)


-- require 'lspconfig'.r_language_server.setup {}

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
-- vim.api.nvim_buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
-- end


lvim.lsp.on_attach_callback = function(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
  local opts = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = 'rounded',
    source = 'always',
    prefix = ' ',
    scope = 'cursor',
  }
  vim.diagnostic.open_float(nil, opts)
end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  --   { command = "isort", filetypes = { "python" } },
  --   {
  --     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  --     command = "prettier",
  --     ---@usage arguments to pass to the formatter
  --     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
  --     extra_args = { "--print-with", "100" },
  --     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --     filetypes = { "typescript", "typescriptreact" },
  --   },
}

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" }, extra_args = { "--line_width=88", "--extend-ignore=E203" } },
  --   {
  --     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  --     command = "shellcheck",
  --     ---@usage arguments to pass to the formatter
  --     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
  --     extra_args = { "--severity", "warning" },
  --   },
  --   {
  --     command = "codespell",
  --     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --     filetypes = { "javascript", "python" },
  --   },
}

-- Additional Plugins
lvim.plugins = {
  {
    { 'github/copilot.vim' },
    { "skywind3000/asyncrun.vim" },
    { "skywind3000/asynctasks.vim" },
    { "hkupty/iron.nvim" },
    { 'GCBallesteros/jupytext.vim' },
    { "rebelot/kanagawa.nvim" },
    {
      "folke/trouble.nvim",
      cmd = "TroubleToggle",
    },
    {
      "tpope/vim-fugitive",
      cmd = {
        "G",
        "Git",
        "Gdiffsplit",
        "Gread",
        "Gwrite",
        "Ggrep",
        "GMove",
        "GDelete",
        "GBrowse",
        "GRemove",
        "GRename",
        "Glgrep",
        "Gedit"
      },
      ft = { "fugitive" }
    },
    { "maxmellon/vim-jsx-pretty" },
    { 'burner/vim-svelte' },
    { "HerringtonDarkholme/yats.vim" },
    {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").init({ "*" }, {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        })
      end,
    },
    {
      "sindrets/diffview.nvim",
      event = "BufRead",
    },
    {
      "pwntester/octo.nvim",
      event = "BufRead",
    },
    {
      "simrat39/symbols-outline.nvim",
      cmd = "SymbolsOutline",
    },
    "tpope/vim-surround",
    keys = { "c", "d", "y" },
    -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
    init = function()
      vim.o.timeoutlen = 500
    end,
    {
      'tikhomirov/vim-glsl'
    },
    { 'timtro/glslView-nvim',
      ft = 'glsl'
    },
    {
      "iamcco/markdown-preview.nvim",
      run = "cd app && npm install",
      ft = "markdown",
    }
  }
};


lvim.autocommands = {
  -- { "VimLeave", "*", "if exists(g:SendCmdToR) && string(g:SendCmdToR) != 'function(SendCmdToR_fake)' | call RQuit('nosave') | endif" },
  --  {
  --    "FileType",
  --    {
  --      pattern = "rmd",
  --      cmd = "set foldmarker=```{,```",
  --    },
  --    "FileType",
  --    {
  --      "rmd",
  --      "setlocal foldmethod=marker"
  --    },
};

-- IronRepl

-- local iron = require("iron.core")

-- iron.setup {
--   config = {
--     repl_definition = {
--       r = {
--         over_ssh = {
--           command = { "ssh", "login@university.org", "R", "--no-save" }
--         },
--         boulder = {
--           command = { "zsh" }
--         },
--         here = {
--           command = { "R", "--no-save" }
--         }
--       },
--       rmd = {
--         over_ssh = {
--           command = { "ssh", "login@university.org", "R", "--no-save" }
--         },
--         here = {
--           command = { "R", "--no-save" }
--         }
--       },
--       -- sometimes I render md using Rmd
--       md = {
--         over_ssh = {
--           command = { "ssh", "login@university.org", "R", "--no-save" }
--         },
--         here = {
--           command = { "R", "--no-save" }
--         }
--       },

--       nim = {
--         inim = {
--           command = { "inim" }
--         }
--       },
--       text = {
--         bash = {
--           command = { "zsh" }
--         }
--       },

--     }
--   },
--   repl_open_cmd = "botright vertical split",
--   preferred = {
--     r = "boulder",
--     rmd = "here",
--     nim = "inim",
--     text = "bash"
--   }
-- }


-- function tab(fallback)
--   local methods = require("lvim.core.cmp").methods
--   local cmp = require "cmp"
--   local luasnip = require "luasnip"
--   local copilot_keys = vim.fn["copilot#Accept"]()
--   if cmp.visible() then
--     cmp.select_next_item()
--   elseif vim.api.nvim_get_mode().mode == "c" then
--     fallback()
--   elseif copilot_keys ~= "" then -- prioritise copilot over snippets
--     -- Copilot keys do not need to be wrapped in termcodes
--     vim.api.nvim_feedkeys(copilot_keys, "i", true)
--   elseif luasnip.expandable() then
--     luasnip.expand()
--   elseif methods.jumpable() then
--     luasnip.jump(1)
--   elseif methods.has_words_before() then
--     fallback()
--   else
--     methods.feedkeys("<Plug>(Tabout)", "")
--   end
-- end;

-- function shift_tab(fallback)
--   local methods = require("lvim.core.cmp").methods
--   local luasnip = require "luasnip"
--   local cmp = require "cmp"
--   if cmp.visible() then
--     cmp.select_prev_item()
--   elseif vim.api.nvim_get_mode().mode == "c" then
--     fallback()
--   elseif methods.jumpable(-1) then
--     luasnip.jump(-1)
--   else
--     local copilot_keys = vim.fn["copilot#Accept"]()
--     if copilot_keys ~= "" then
--       methods.feedkeys(copilot_keys, "i")
--     else
--       methods.feedkeys("<Plug>(Tabout)", "")
--     end
--   end
-- end;
