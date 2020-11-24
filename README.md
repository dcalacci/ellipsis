# ellipsis

... very okay dotfiles

Set of dotfiles, including various scripts and tools I use on a 2020 macbook air with a very
unfortunate cooling problem.

## vim

After years of using emacs, I gave up, and now I use neovim, and make liberal use of [coc.nvim](https://github.com/neoclide/coc.nvim). It's
like vscode but way cooler because it runs in your terminal. My init.vim is fairly
straightforward but the general features are:

- autocomplete, linting, and prettier for most languages, including R and Typescript
- literate programming / REPL support for IPython and R

some niceties:

- `,f` for an overused `fzf` file pane fuzzy finder using `ripgrep`. This absolutely rules
  and is way better than a dumb file pane taking up precious screen real estate.
- `ctrl + j,k,h,l` to navigate windows / panes, and `vv` and `ss` to split.
- `,V` to open a nice code map using `vista`
- `[g` and `]g` to go through diagnostics (great for typescript)
- `,s` to start a slime session with an ipython. you can change the interpreter pretty
  easily, which is killer. then do `,h` or `,C` to send code.
- `,F` to format your code perfectly every time

## kitty

I started using [`kitty`](https://sw.kovidgoyal.net/kitty/) sometime in 2020, after being
exhausted by waiting more than half a second for some dumb rendering to finish in my
terminal. now everything is super fast and I don't even have to think about it. The config in
`kitty/kitty.conf` is mainly my color setup.

## bash

After about a decade using `zsh` or `fish`, I've decided I don't care anymore and am tired of
my shell being slow.

## tiling window manager

I missed linux so much that i started using a tiling window manager,
[yabai](https://github.com/koekeishiya/yabai). [koekeishiya](github.com/koekeishiya) has been
making crazy WM software for mac osx for years and this is by far the easiest, fastest, and
best one.

I use [skhd](https://github.com/koekeishiya/skhd), as they suggest, to manage keybindings.
`cmd+shift+m` to open my mail anywhere? yes please.
