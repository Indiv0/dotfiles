" Indents that consist of 4 space characters but are entered with the tab key
" show existing tab with 4 spaces width
set tabstop=4 softtabstop=4
" when indenting with the '>', use 4 spaces width
set shiftwidth=4
" when indenting with the tab key, insert 4 spaces
set expandtab

" Enable syntax highlighting
syntax on

" Enable file type based indentation
filetype plugin indent on

" When opening html, css, and js files use 2 space characters for indent
" instead of 4
autocmd BufEnter *.html,*.css,*.js set shiftwidth=2 tabstop=2 softtabstop=2

" Enable rust-analyzer for rust language files via ALE.
let g:ale_linters = {'rust': ['analyzer']}
" Enable ALE autocompletion where available.
" This setting must be set before ALE is loaded.
let g:ale_completion_enabled = 1
" Enable ALE automatic imports from external modules.
let g:ale_completion_autoimport = 1
" Disable unresolved import check because for some reason it has false
" positives on cargo dependencies.
let g:ale_rust_analyzer_config =
  \ {
  \   'diagnostics': { 'disabled': ['unresolved-import'] }
  \ }
