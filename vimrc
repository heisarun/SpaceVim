"=============================================================================
" vimrc --- Entry file for vim
" Copyright (c) 2016-2022 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Use XDG paths if available
if !empty($XDG_CONFIG_HOME) && !empty($XDG_DATA_HOME) && !empty($XDG_STATE_HOME)
    set runtimepath^=$XDG_CONFIG_HOME/vim
    set runtimepath+=$XDG_DATA_HOME/vim
    set runtimepath+=$XDG_CONFIG_HOME/vim/after

    if exists('&packpath')
      set packpath^=$XDG_DATA_HOME/vim,$XDG_CONFIG_HOME/vim
      set packpath+=$XDG_CONFIG_HOME/vim/after,$XDG_DATA_HOME/vim/after
    endif

    let g:netrw_home = $XDG_DATA_HOME."/vim"
    if !isdirectory($XDG_DATA_HOME."/vim")
      call mkdir($XDG_DATA_HOME."/vim", 'p')
    endif
    call mkdir($XDG_DATA_HOME."/vim/spell", 'p')

    set backupdir=$XDG_STATE_HOME/vim/backup | call mkdir(&backupdir, 'p')
    set directory=$XDG_STATE_HOME/vim/swap   | call mkdir(&directory, 'p')
    set undodir=$XDG_STATE_HOME/vim/undo     | call mkdir(&undodir,   'p')
    set viewdir=$XDG_STATE_HOME/vim/view     | call mkdir(&viewdir,   'p')

    if !has('nvim') | set viminfofile=$XDG_STATE_HOME/vim/viminfo | endif
endif

" Note: Skip initialization for vim-tiny or vim-small.
if 1
    let g:_spacevim_if_lua = 0
    if has('lua')
        " add ~/.SpaceVim/lua to lua package path
        if has('win16') || has('win32') || has('win64')
            let s:plugin_dir = fnamemodify(expand('<sfile>'), ':h').'\lua'
            let s:str = s:plugin_dir . '\?.lua;' . s:plugin_dir . '\?\init.lua;'
        else
            let s:plugin_dir = fnamemodify(expand('<sfile>'), ':h').'/lua'
            let s:str = s:plugin_dir . '/?.lua;' . s:plugin_dir . '/?/init.lua;'
        endif
        silent! lua package.path=vim.eval("s:str") .. package.path
        if empty(v:errmsg)
            let g:_spacevim_if_lua = 1
        endif
    endif
    execute 'source' fnamemodify(expand('<sfile>'), ':h').'/init.vim'
endif
" vim:set et sw=2

if has('win32') || has('win64')
  Plug 'tbodt/deoplete-tabnine', { 'do': 'powershell.exe .\install.ps1' }
else
  Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
endif

if has('win32') || has('win64')
  call dein#add('tbodt/deoplete-tabnine', { 'build': 'powershell.exe .\install.ps1' })
else
  call dein#add('tbodt/deoplete-tabnine', { 'build': './install.sh' })
endif

call plug#begin()
" List your plugins here
Plug 'vim-ruby/vim-ruby'
call plug#end()

auto_completion_return_key_behavior = "complete"
auto_completion_tab_key_behavior = "cycle"
set fencs=latin1
set enc = iso-8859-1
guifont = "Agave Nerd Font Regular:h14"
snippet_engine = "ultisnips"
enable_guicolors = true
autocomplete_method = "deoplate"
snippet_engine ="ultisnips"
filemanager = "defx"

" Required
Plug 'neovim/nvim-lsp'
" Plugin
Plug 'robert-oleynik/clangd-nvim'

lua << EOF
local clangd_nvim = require'clangd_nvim'

require'nvim_lsp'.clangd.setup{
    capabilities = {
        textDocument = {
            semanticHighlightingCapabilities = {
                semanticHighlighting = true
            }
        }
    },
    on_init = clangd_nvim.on_init
}
EOF

augroup ConfigSetup
    autocmd!
    autocmd VimEnter,ColorScheme * runtime syntax/custom_colors.vim
augroup END
