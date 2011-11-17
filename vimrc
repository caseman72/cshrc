
let java_allow_cpp_keywords=1
let java_highlight_all=1
let template=1

let g:man_vim_only=1
let g:man_split=0

let filetype_i="mips"

" Turn on syntax hilighting
syntax on

runtime ftplugin/man.vim
runtime macros/matchit.vim
runtime plugins/matchit.vim

source $HOME/.exrc

" Local function
for f in split(glob('*.func'), '\n')
  if filereadable(f)
    silent exec ':source ' . f
  endif
endfor

