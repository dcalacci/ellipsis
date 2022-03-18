" ============= Vim-Plug ============== "{{{

let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')
" let g:python_host_prog = '/opt/anaconda3/bin/python'
let g:vim_bootstrap_langs = "python,javascript,R"
let g:vim_bootstrap_editor = "nvim"				" Nvim or Vim

" incorporate ALE w CoC
" https://github.com/dense-analysis/ale#faq-coc-nvim
let g:ale_disable_lsp = 1


if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!\curl -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"
  autocmd VimEnter * PlugInstall
endif

call plug#begin(expand('~/.config/nvim/plugged'))

"}}}

" ================= looks and GUI stuff ================== "{{{

Plug 'ayu-theme/ayu-vim-airline'
Plug 'vim-airline/vim-airline'                          " airline status bar
Plug 'ryanoasis/vim-devicons'                           " pretty icons everywhere
Plug 'gregsexton/MatchTag'                              " highlight matching html tags
Plug 'scrooloose/nerdtree'
Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'

"}}}

" ================= Functionalities ================= "{{{

" auto completion, Lang servers and stuff
Plug 'neoclide/coc.nvim', {'branch': 'release'}


" better diagnostic output 
Plug 'kyazdani42/nvim-web-devicons'
Plug 'arafatamim/trouble.nvim'
Plug 'folke/lsp-colors.nvim'

" fuzzy stuff
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" snippets
" Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'                               " actual snippets

" visual
Plug 'alvan/vim-closetag'                               " auto close html tags
Plug 'Yggdroot/indentLine'                              " show indentation lines

" languages
"Plug 'tpope/vim-liquid'                                 " liquid language support
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
Plug 'jparise/vim-graphql'

" Interactive python
Plug 'hdima/python-syntax'
Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }

" Writing
Plug 'vim-pandoc/vim-pandoc'
Plug 'junegunn/goyo.vim'                                " 'distraction-free' mode for writing
Plug 'junegunn/limelight.vim'                           " dims all lines except current
Plug 'plasticboy/vim-markdown'                          " markdown support

" R and R notebooks
Plug 'vim-pandoc/vim-pandoc-syntax',  {'for': ['rmd', 'md']}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }} " markdown-preview
Plug 'vim-pandoc/vim-rmarkdown'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'jalvesaq/Nvim-R'
Plug 'gaalcaras/ncm-R'
Plug 'jalvesaq/R-Vim-runtime', {'for': ['r', 'rmd']}
Plug 'vim-pandoc/vim-pandoc-syntax',  {'for': ['rmd', 'md']}

"Plug 'sheerun/vim-polyglot'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'for': ['typescript', 'tsx'], 'do': './install.sh' }
" For async completion
" For Denite features
Plug 'Shougo/denite.nvim'
" Typescript
"Plug 'leafgarland/typescript-vim'
"Plug 'peitalin/vim-jsx-typescript'

" fixes some problems with typescript formatting 
autocmd BufEnter *.{js,jsx,ts,tsx,py} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx,py} :syntax sync clear

" fixes some problems with typescript formatting 
autocmd BufEnter *.{js,jsx,ts,tsx,py} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx,py} :syntax sync clear


" Vim 8 only
if !has('nvim')
    Plug 'roxma/vim-hug-neovim-rpc'
endif

" Optional: for snippet support
" Further configuration might be required, read below
" Plug 'sirver/UltiSnips'
" Plug 'ncm2/ncm2-ultisnips'

" Optional: better Rnoweb support (LaTeX completion)
Plug 'lervag/vimtex'

" Tmux integration
"Plug 'wellle/tmux-complete.vim'                         " complete words from a tmux panes (I found this annoying)
Plug 'christoomey/vim-tmux-navigator'                   " lets you jump with h,j,k,l into tmux panes

" other
Plug 'tpope/vim-commentary'                             " better commenting
Plug 'tpope/vim-fugitive'                               " git support
Plug 'psliwka/vim-smoothie'                             " some very smooth ass scrolling
Plug 'farmergreg/vim-lastplace'                         " open files at the last edited place
Plug 'liuchengxu/vista.vim'                             " a bar of tags
Plug 'tpope/vim-eunuch'                                 " run common Unix commands inside Vim
Plug 'machakann/vim-sandwich'                           " make sandwiches
Plug 'easymotion/vim-easymotion'                        " make movement a lot faster and easier
Plug '907th/vim-auto-save'                              " nothing beats this
Plug 'ayu-theme/ayu-vim' " or other package manager
call plug#end()

"}}}

" ==================== general config ======================== "{{{
" set macmeta
set nowrap                                              " No line wrap by default
set termguicolors                                       " Opaque Background
set mouse=a                                             " enable mouse scrolling
set clipboard+=unnamedplus                              " use system clipboard by default
filetype plugin indent on                               " enable indentations
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab "autoindent            " tab key actions
set incsearch ignorecase smartcase hlsearch             " highlight text while searching
set list listchars=trail:»,tab:»-                       " use tab to navigate in list mode
set fillchars+=vert:\▏                                  " requires a patched nerd font (try FiraCode)
let &showbreak = '↳'
set cpo=n
set linebreak
" set wrap "breakindent                                    " wrap long lines to the width set by tw
set encoding=utf-8                                      " text encoding
" set number                                              " enable numbers on the left
set relativenumber                                      " current line is 0
set title                                               " tab title as file name
set noshowmode                                          " dont show current mode below statusline
set conceallevel=2                                      " set this so we wont break indentation plugin
set splitright                                          " open vertical split to the right
set splitbelow                                          " open horizontal split to the bottom
" set tw=100                                               " auto wrap lines that are longer than that
set emoji                                               " enable emojis
let g:indentLine_setConceal = 0                         " actually fix the annoying markdown links conversion
au BufEnter * set fo-=c fo-=r fo-=o                     " stop annoying auto commenting on new lines
set history=1000                                        " history limit
set backspace=indent,eol,start                          " sensible backspacing
set undofile                                            " enable persistent undo
set undodir=/tmp                                        " undo temp file directory
set foldlevel=0                                         " open all folds by default
set inccommand=nosplit                                  " visual feedback while substituting
let loaded_netrw = 0                                    " diable netew
let g:omni_sql_no_default_maps = 1                      " disable sql omni completion
set nobackup                                            " disable tilde files (will I regret this later?)
"set backupdir=~/tmp
" Disable swap files altogether
set noswapfile                                          " disable swap files (will I regret this?)

""""""""""""""""""""""""""""""""""""""""""""""""""""
" writing - use 'Goyo' to start writing mode.
nnoremap <Leader>gy :Goyo<CR>
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" navigate with visual / soft line wraps instead of hard by default
noremap j gj
noremap k gk

let R_set_omnifunc = [] " do not use nvim completion (using coc)
" set rmd files to rmarkdown type
autocmd BufRead,BufNewFile *.rmd set filetype=rmarkdown


let g:tex_flavor = 'latex'

" detect system type. Will be 'Windows' if windows, 'Darwin' if mac, and 'Linux' if linux.
if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

if g:os == "Darwin"
    " Python VirtualEnv
    let g:python_host_prog =  expand('/Users/dcalacci/.pyenv/versions/3.9.1/bin/python')
    let g:python3_host_prog = expand('/Users/dcalacci/.pyenv/versions/3.9.1/bin/python3')
else
    let g:python_host_prog =  expand('/opt/anaconda3/bin/python')
    let g:python3_host_prog = expand('/opt/anaconda3/bin/python3')
endif

let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"

" Coloring
set termguicolors     " enable true colors support
let ayucolor="dark"  " for light version of theme
colorscheme ayu
" highlight Cursor guibg=#0f111a guifg=#eeeeee
" highlight iCursor guifg=#0f111a guibg=#eeeeee
" highlight Pmenu guibg='#00010a' guifg=white              " popup menu colors
" highlight Comment guifg=#fafafa guibg=#abb0b6 gui=italic cterm=italic               " bold comments
highlight Normal gui=none
highlight NonText guibg=none
highlight clear SignColumn                              " use number color for sign column color
" highlight rComment guifg=#fafafa guibg=#abb0b6 gui=italic cterm=italic               " bold comments

" hi Search guibg=#abb0b6 guifg=#fafafa          " search string highlight color
autocmd ColorScheme * highlight VertSplit cterm=NONE    " split color
hi NonText guifg=bg                                     " mask ~ on empty lines
hi clear CursorLineNr                                   " use the theme color for relative number
hi CursorLineNr gui=bold                                " make relative number bold
hi EasyMotionMoveHL guibg=#b16286 guifg=#ebdbb2 gui=NONE

" colors for git (especially the gutter)
" hi DiffAdd guifg=#43a047 guibg=#fafafa
" hi DiffChange guifg=#fdd835 guibg=#fafafa
" hi DiffRemoved guifg=#e53935 guibg=#fafafa

" coc multi cursor highlight color
hi CocCursorRange guibg=#b16286 guifg=#ebdbb2


" performance tweaks
set nocursorline
set nocursorcolumn
set scrolljump=5
set lazyredraw
set redrawtime=10000
set synmaxcol=180
" need to set re=0 for YATS (typescript)
set re=0

" required by coc
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes


" tmux cursor shape
if exists('$TMUX')
    let &t_SI .= "\ePtmux;\e\e[=1c\e\\"
    let &t_EI .= "\ePtmux;\e\e[=2c\e\\"
 else
    let &t_SI .= "\e[=1c"
    let &t_EI .= "\e[=2c"
 endif

"}}}

" ======================== Plugin Configurations ======================== "{{{

" Airline
let g:airline_theme='ayu'
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#themes#clean#palette = 1
call airline#parts#define_raw('linenr', '%l')
call airline#parts#define_accent('linenr', 'bold')
let g:airline_section_z = airline#section#create(['%3p%%  ',
            \ g:airline_symbols.linenr .' ', 'linenr', ':%c '])
let g:airline_section_warning = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2   " show tabline only if there is more than 1 buffer
let g:airline#extensions#tabline#fnamemod = ':t'        " show only file name on tabs
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let airline#extensions#vista#enabled = 1                " vista integration

let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1

"" coc
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Navigate snippet placeholders using tab
let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'

" Use enter to accept snippet expansion
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" notes on coc config:
" https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim
" list of the extensions required
let g:coc_global_extensions = [
            \'coc-yank',
            \'coc-emmet',
            \'coc-json',
            \'coc-eslint',
            \'coc-css',
            \'coc-html',
            \'coc-tsserver',
            \'coc-yaml',
            \'coc-lists',
            \'coc-snippets',
            \'coc-pyright',
            \'coc-clangd',
            \'coc-prettier',
            \'coc-xml',
            \'coc-rls',
            \'coc-syntax',
            \'coc-flutter',
            \'coc-git'
            \]


" indentLine
let g:indentLine_char = '▏'
let g:indentLine_color_gui = '#363949'

" rainbow brackets
let g:rainbow_active = 1

" easymotion
let g:EasyMotion_startofline = 0                        " keep cursor column when JK motion
let g:EasyMotion_smartcase = 1                          " ignore case

" auto save when text is changed, modes or changed, or focus changes.
" don't tell me about it, just do it
let g:auto_save        = 1
let g:auto_save_silent = 1
let g:auto_save_events = ["FocusLost"]

" semshi settings
let g:semshi#error_sign	= v:false                       " let ms python lsp handle this


"" FZF

" general
" we put fzf in a floating window isntead of the bottom
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }
let $FZF_DEFAULT_OPTS="--reverse "                      " top to bottom

" use rg by default
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
endif

"}}}

" ======================= Slime ===================================== {{{
" use tmux for slime
let g:slime_target = 'tmux'
" fix paste issues in ipython
let g:slime_python_ipython = 1
" always send text to the top-right pane in the current tmux tab without asking
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': '{top-right}' }
let g:slime_dont_ask_default = 1
"}}}

" Radian integration with NVim-R {{{
let R_app = "radian"
let R_cmd = "R"
let R_hl_term = 0
let R_args = []
let R_bracketed_paste = 1
let R_in_buffer = 0

" formatting when leaving insert mode 
 " augroup myformatting
 "     autocmd!
 "     autocmd InsertLeave * normal gwap<CR>
 " augroup END

" ======================== Auto Commands ============================= "{{{

" enable spell only if file type is normal text
let spellable = ['markdown', 'gitcommit', 'txt', 'text', 'liquid']
autocmd BufEnter * if index(spellable, &ft) < 0 | set nospell | else | set spell | endif

" open help in vertical split
autocmd FileType help wincmd L

" open files preview on enter and provided arg is a folder
autocmd VimEnter * if argc() != 0 && isdirectory(argv()[0]) | execute 'cd' fnameescape(argv()[0])  | endif
autocmd VimEnter * if argc() != 0 && isdirectory(argv()[0]) | Files | endif

" auto html tags closing, enable for markdown files as well
let g:closetag_filenames = '*.html,*.xhtml,*.phtml, *.md'

" python stuff
autocmd FileType python nnoremap <leader>rn :Semshi rename

" relative numbers on normal mode only
" augroup numbertoggle
"   autocmd!
"   autocmd InsertLeave * set relativenumber
"   autocmd InsertEnter * set norelativenumber
" augroup END

"}}}

" ================== Custom Functions ===================== "{{{

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" Setup formatexpr specified filetype(s).
autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" coc prettier function
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" files window with preview
command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)


" advanced grep(faster with preview)
function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

" floating fzf window with borders
function! CreateCenteredFloatingWindow()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

" show docs on things with K
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"}}}

" vista "{{{

let g:vista_sidebar_width = 30
"}}}

" ======================== Custom Mappings ====================== "{{{

"" the essentials
let mapleader=","
nnoremap ; :
nmap \ <leader>q
map <F4> :Vista!!<CR>
nmap <leader>r :so ~/.config/nvim/init.vim<CR>
nmap <leader>q :bd<CR>
map <leader>V :Vista coc<CR>
map <leader>v :Vista focus<CR>
nnoremap <silent> <leader>f :Files<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>c :Commands<CR>
map <leader>/ :Rg<CR>
nmap <leader>w :w<CR>
map <leader>F :Format<CR>
nmap <Tab> :bnext<CR>
nmap <S-Tab> :bprevious<CR>
noremap <leader>e :PlugInstall<CR>
noremap <C-q> :q<CR>
inoremap jj <ESC>

nnoremap <silent> <C-t> :NERDTreeToggle<CR>
nnoremap <leader>t :NERDTreeFocus<CR>

" Session setting
nnoremap <leader>cs :mksession! ~/.config/nvim/sessions/
nnoremap <leader>os :source ~/.config/nvim/sessions/
nnoremap <leader>rs :!rm ~/.config/nvim/sessions/


"" <alt> + XX will do single motions in insert mode
inoremap <A-h> <C-o>h
inoremap <A-j> <C-o>j
inoremap <A-k> <C-o>k
inoremap <A-l> <C-o>l

" use a different buffer for delete and paste
" nnoremap d "_d
" vnoremap d "_d
" vnoremap p "_dP
" nnoremap x "_x

" emulate windows copy, cut behavior
vnoremap <LeftRelease> "+y<LeftRelease>
vnoremap <C-c> "+y<CR>
vnoremap <C-x> "+d<CR>

" switch between splits using ctrl + {h,j,k,l}
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
inoremap <C-h> <C-\><C-N><C-w>h
inoremap <C-j> <C-\><C-N><C-w>j
inoremap <C-k> <C-\><C-N><C-w>k
inoremap <C-l> <C-\><C-N><C-w>l
nnoremap <C-h> <C-w>h
noremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> vv <C-w>v

" nnoremap <silent>b :ls<cr>:b<space>
nnoremap <silent>vv :ls<cr>:vsp<space>\|<space>b<space>
nnoremap <silent>ss :ls<cr>:sp<space>\|<space>b<space>
"" slime mappings


"-----------------
" R config
"-----------------
let R_assign = 0
let Rout_more_colors = 1

"------------------------------------------------------------------------------
" ipython-cell configuration
"------------------------------------------------------------------------------

" " map <Leader>s to start IPython
nnoremap <Leader>s :SlimeSend1 ipython --matplotlib<CR>

" " map <Leader>r to run script
" nnoremap <Leader>R :IPythonCellRun<CR>

" " map <Leader>R to run script and time the execution
" " nnoremap <Leader>R :IPythonCellRunTime<CR>

" " map <Leader>c to execute the current cell
" nnoremap <Leader>C :IPythonCellExecuteCell<CR>

" " map <Leader>C to execute the current cell and jump to the next cell
" " nnoremap <Leader>C :IPythonCellExecuteCellJump<CR>

" " map <Leader>l to clear IPython screen
" nnoremap <Leader>L :IPythonCellClear<CR>

" " map <Leader>x to close all Matplotlib figure windows
" nnoremap <Leader>x :IPythonCellClose<CR>

" " map [c and ]c to jump to the previous and next cell header
" nnoremap [c :IPythonCellPrevCell<CR>
" nnoremap ]c :IPythonCellNextCell<CR>

" " map <Leader>h to send the current line or current selection to IPython
nmap <Leader>h <Plug>SlimeLineSend
xmap <Leader>h <Plug>SlimeRegionSend

" " map <Leader>p to run the previous command
" nnoremap <Leader>p :IPythonCellPrevCommand<CR>

" " map <Leader>Q to restart ipython
" nnoremap <Leader>Q :IPythonCellRestart<CR>

" " map <Leader>d to start debug mode
" nnoremap <Leader>d :SlimeSend1 %debug<CR>

" " map <Leader>q to exit debug mode or IPython
nnoremap <Leader>sq :SlimeSend1 exit<CR>

"" coc mappings
" multi cursor shortcuts
nmap <silent> <C-c> <Plug>(coc-cursors-position)
nmap <silent> <C-a> <Plug>(coc-cursors-word)
xmap <silent> <C-a> <Plug>(coc-cursors-range)

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" do something about the diagnostic if you can
nmap <leader>do <Plug>(coc-codeaction)

" for global rename
nmap <leader>rn <Plug>(coc-rename)

" new line in normal mode and back
map <Enter> o<ESC>
map <S-Enter> O<ESC>

" jump stuff
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" showing documentation / diagnostics
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <buffer> H :<C-u>execute "!pydoc3 " . expand("<cword>")<CR>

" " show diagnostic if it exists, otherwise documentation
" function! ShowDocIfNoDiagnostic(timer_id)
"   if (coc#float#has_float() == 0)
"     silent call CocActionAsync('doHover')
"   endif
" endfunction

" function! s:show_hover_doc()
"   call timer_start(500, 'ShowDocIfNoDiagnostic')
" endfunction

" autocmd CursorHoldI * :call <SID>show_hover_doc()
" autocmd CursorHold * :call <SID>show_hover_doc()

" Vim Script
" nnoremap <leader>xx <cmd>TroubleToggle<cr>
" nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
" nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
" nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
" nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nmap <silent> xx <cmd>call coc#rpc#request('fillDiagnostics', [bufnr('%')])<CR><cmd>Trouble loclist<CR>`
nmap <silent> xw <cmd>call coc#rpc#request('fillDiagnostics', [bufnr('%')])<CR><cmd>TroubleToggle workspace_diagnostics<CR>`
nmap <silent> xd <cmd>call coc#rpc#request('fillDiagnostics', [bufnr('%')])<CR><cmd>TroubleToggle document_diagnostics<CR>`
nmap <silent> xq <cmd>call coc#rpc#request('fillDiagnostics', [bufnr('%')])<CR><cmd>TroubleToggle quickfix<CR>`


" Doagnostics with Trouble
lua << EOF
require("trouble").setup {
    height = 10, -- height of the trouble list
    icons = true, -- use devicons for filenames
    mode = "document_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
    action_keys = { -- key mappings for actions in the trouble list
        close = "q", -- close the list
        cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r", -- manually refresh
        jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
        jump_close = {"o"}, -- jump to the diagnostic and close the list
        toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = "P", -- toggle auto_preview
        hover = "K", -- opens a small poup with the full multiline message
        preview = "p", -- preview the diagnostic location
        close_folds = {"zM", "zm"}, -- close all folds
        open_folds = {"zR", "zr"}, -- open all folds
        toggle_fold = {"zA", "za"}, -- toggle fold of current file
        previous = "k", -- preview item
        next = "j" -- next item
    },
    indent_lines = true, -- add an indent guide below the fold icons
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = false, -- automatically close the list when you have no diagnostics
    auto_preview = true, -- automatyically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    },
    use_lsp_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
}
EOF


"" easy motion stuff
" search behavior
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" quick navigation
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

" fugitive mappings
map <leader>d :Gdiffsplit<CR>

" disable hl with 2 esc
noremap <silent><esc> <esc>:noh<CR><esc>

"}}}
