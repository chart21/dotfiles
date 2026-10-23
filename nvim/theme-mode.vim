" Light/dark mode shared with the desktop toggle (Super+Shift+T, ~/.config/X11/theme-mode).
" Sourced by init.vim at start-up and by theme-mode in every running Neovim.
let s:f = expand('~/.config/theme-mode')
if filereadable(s:f) && get(readfile(s:f, '', 1), 0, '') ==# 'dark'
  set background=dark
  silent! colorscheme gruvbox
else
  set background=light
  silent! colorscheme github
endif
if exists('g:loaded_lightline')
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endif
