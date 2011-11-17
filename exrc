set nocompatible                  " much better
set syntax=php                    " start with php
set sw=2                          " 2 spaces when indenting
set ts=2                          " 2 spaces when tabbing
set sts=2                         " 2 spaces when deleting
set noeol                         " do not set eol automattically
set nohlsearch                    " don't highlight search matches
set incsearch                     " find word as you type search
set ruler                         " status at the bottom
set nowrap                        " don't wrap lines
set lbr                           " when wrap is on, wrap at space
set nu                            " show line numbers
set noerrorbells                  " don't beep at me
set vb
set t_vb=
set ttyfast                       " type as fast as possible
set backspace=indent,eol,start    " when backspacing wrap to previous line
set autowrite                     " auto saves
set splitbelow
set encoding=utf-8
" set t_ti=                         " don't clear the screen
" set t_te=

" conditional whitespace
:if ($HOST =~ '^\(?:[aA]rea52\|wdt-casey\|tengen\|swamp\|machone\|pvpdev\|rackdev\)')
: set et
:else
: set noet
:endif


" set showmatch
" set matchpairs+=<:>

set ai
set si
set copyindent
set cindent
set cinkeys=0{,0},0),!^F,o,O,e    " remove # as 0 indent
set comments=n:#                  " comment
set foldlevelstart=99             " no folds

set laststatus=2                  " ls:  always put a status line
set statusline=%([%-n]%y\ %t%m%r%)\ %{CurrSubName()}\ %=\ %(%l,%v\ %P\ [0x%02.2B]%)

" Stop the annoying behavior of leaving comments on far left
set fo+=r

set list
set listchars=tab:\\t,extends:%,precedes:%,trail:~,eol:$

" set iskeyword-=-                  " remove dash to stop at dash for words
" set iskeyword-=_                  " remove under to stop at under for words
set iskeyword+="->"


""" Leaders \
"
map <silent> <Leader>w <Esc>:exe '!echo -n "' substitute(getline("."),'\(["#\\]\)','\\\1','g') '"' "\|aspell -a list \|sed '/^[^&]/d'"<CR>
map <Leader>s <Esc>:!aspell -c --dont-backup "%"<CR>:e! "%"<CR><CR>
map <Leader>c ^80lbi<CR><ESC><<<<<<
map <Leader>r <Esc>:s/\(<[a-z][a-z]*[^>][^>]\{-}\)\( [a-z]*[=]\)\([^" >][^" >]*\)/\1\2"\3"/gc<CR>
map <Leader>e <Esc>:s/\(\$[a-zA-Z0-9_][a-zA-Z0-9_>-]*\)/{\1}/gc<CR>
map <Leader>u <Esc>:%s/\(<\/\?[a-zA-Z]\+\)/\L\1/gc<CR>
map <Leader>hex :%!xxd<CR>
map <Leader>!hex :%!xxd -r<CR>

imap <Leader>v <C-O>:set paste<CR>

map! <C-]> <Esc>I<Home>#<Esc>j<Home>
map <C-]> <Esc>I<Home>#<Esc>j<Home>

let perl_extended_vars=1
let b:match_words = '(:),{:},[:],<?:?>,<\([^\/ >]*\)[ >]:<\/\1>,<<EOS:EOS;,\<if\s*(.\{-})\s*:\<else.:\<endif.'

" toggles folds opened and closed
nnoremap <C-z> za

" in visual mode creates a fold over the marked range
vnoremap <C-z> zf

" Search search and replace
nnoremap <silent> , .<CR>:call histdel('search', -1)<Bar>let @/=histget('search',-1)<CR>n

"""" Movement
"    o work more logically with wrapped lines
noremap j gj
noremap k gk
noremap '' ''zz
noremap <C-j> <C-y>
noremap <C-k> <C-e>

""" Indenting
nnoremap <Tab> >>
" nnoremap <S-Tab> <<

"" FKeys
 " F10 - linenumbers on/off
 " F11 - insert (paste) on/off
 " F12 - word wrap on/off
""
if has("gui_kde")
  " gvim has it's own FKey macros...
else
  nnoremap <F5> :set list! list?<CR>
  inoremap <F5> <C-O>:set list! list?<CR>

  nnoremap <F6> :call CygwinCopy()<CR>
  nnoremap <F7> :call CygwinPaste()<CR>

"   nnoremap <F6> :call MapPL()<CR>
"   nnoremap <F7> :call MapPHP()<CR>
"  nnoremap <F8> :call MapPHP()<CR>
  nnoremap <F8> :set wrap! wrap?<CR>
  inoremap <F8> <C-O>:set wrap! wrap?<CR>

  nnoremap <F9> :set nohlsearch! nohlsearch?<CR>
  inoremap <F9> <C-O>:set nohlsearch! nohlsearch?<CR>

  nnoremap <F10> :if &nu <Bar> set nonu nolist <Bar> else <Bar> set nu list <Bar> endif <Bar> set nu?<CR>
  inoremap <F10> <C-O>:if &nu <Bar> set nonu nolist <Bar> else <Bar> set nu list <Bar> endif <Bar> set nu?<CR>

  set pastetoggle=<F11>
"  nnoremap <F11> :if &fo == '' <Bar> set fo=tcqr <Bar> else <Bar> set fo= <Bar> endif <Bar> set fo?<CR>

  nnoremap <F12> :set wrap! wrap?<CR>
  inoremap <F12> <C-O>:set wrap! wrap?<CR>
endif


"============================================================================
" Abbreviations
"----------------------------------------------------------------------------
" abbreviate udd use Data::Dumper;<CR>local $Data::Dumper::Sortkeys=1;<CR>print Dumper();<CR>


""" Edit mode macros
  "
  " F     - goto to the next file
  " E     - goto the other file
  " 2h    - creates web page with syntax coloring
  " tw    - replaces word with word in buffer
  " t2    - sets tabs to 2 spaces
  " t4    - sets tabs to 4 spaces
  " ^[[7^ - maps ctrl+home to first line
"""
map F :n<CR>
map E :e#<CR>
noremap H <C-F>L
noremap L <C-B>H
map n nzz
map N Nzz
" map o p`[
" map O P`[
map 2h :runtime! syntax/2html.vim<CR>
map tw dw"0Pw
map t1 :set noet! noet?<CR>
map t2 :set ts=2 sw=2 sts=2<CR>
map t4 :set ts=4 sw=4 sts=4<CR>
map [7^ <Esc>:1<CR>
map! [7^ <Esc>:1<CR>i
map :Q :q!
map $% >%<<%<<%
map $# <%>>%>>%
map $$ :<Up><CR>
map () bhi{<Esc>2wi}<Esc>bh
map {} bhi{<Esc>2wi}<Esc>bh
noremap Q q
noremap q :q

"""" Insert mode macros
   "
   " ^[[3~ - maps delete to right backspace
   " ^[[7^ - maps ctrl+home to first line
   " <Nul> - maps ctrl+space to ctrl+n (code completion)
""""
map! [3~ <Right><BS>
imap <Nul> <C-n>
imap <C-F> <C-x><C-o>

" Search for selected text, forwards
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

function! DoFormatXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " Things that need fixin
  "
  silent! exec '%s/[&]nbsp;/\&#160;/g'
  silent! exec '%s/[&]copy;/\&#169;/g'

  " Image hacker
  while search( '<img[^>]*>\(.*$\n\)\+<\/img>', 'ncw')
    silent! exec 'g/<img[^>]*>\(.*$\n\)\+<\/img>/s/\n//g'
  endwhile
  silent! exec '%s/<img/<img/g'
  silent! exec 'g!/<\/img>/s/<img\([^>]*[^\/]\)>/<img\1\/>/g'

  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1s/<?xml .*?>/<?xml version="1.0" encoding="UTF-8"?>/e
  silent! exec '%s/[<]\(\(td\|a\|textarea\|div\|iframe\|span\)[^>]*\)\/[>]/<\1><\/\2>/g'
  silent! exec '%s/[&]#x[Aa]0;/\&#160;/g'
  silent! exec '%s/[&]#x[Aa]9;/\&#169;/g'
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! FormatXML call DoFormatXML()

function! DoFormatPHP()
  0
  silent! exec '%s/^\s\s*//g'
  silent! exec '%s/\s\s*$//g'
  silent! exec '%s/<[?]php\s*\(.*\)[?]>$/<?\1?>/g'
  silent! exec '%s/<[?]\s*\(.*\)[?]>$/<?\1?>/g'
  silent! exec '%s/\n\n\n*//g'
  silent! exec '%s/)\s*{/){/g'
  silent! exec '%s/}\s*else\s*{/}else{/g'
  silent! exec '%s/\n\n\n*//g'

  $
  let lastline = line('.')

  0
  exec 'normal! 0'

  let cur = 1
  while cur <= lastline
    let indent = matchstr(getline(cur), '^\s*{')
    if strlen(indent) > 0
      exec 'normal! >%<<%<<%'
    endif
    exec 'normal! j0'

    let cur = cur + 1
  endwhile

endfunction
command! FormatPHP call DoFormatPHP()

function! DoStripHTML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " Things that need fixin
  "
  silent! exec '%s///g'
  1
  silent! exec 's/<!\(DOCTYPE.\{-}\)>/<!-- \1 -->/'
  silent! exec '%s/\(<\/\?[a-zA-Z]*\)/\L\1/g'
  silent! exec '%s/[&]nbsp;/\&#160;/g'
  silent! exec '%s/[&]copy;/\&#169;/g'
  silent! exec '%s/\(<br[^\/>]*\)>/\1\/>/g'
  silent! exec '%s/<a href="https\?:\/\/[^"]*"/<a href="#"/g'

  " Script hacker
  while search( '<script[^>]*>\(.*$\n\)\+<\/script>', 'ncw')
    silent! exec 'g/<script[^>]*>\(.*$\n\)\+<\/script>/s/\n//g'
  endwhile
  silent! exec '%s/<script.\{-}<\/script>//g'

  " Input hacker
  while search( '<input[^>]*>\(.*$\n\)\+<\/input>', 'ncw')
    silent! exec 'g/<input[^>]*>\(.*$\n\)\+<\/input>/s/\n//g'
  endwhile
  silent! exec '%s/<input/<input/g'
  silent! exec 'g!/<\/input>/s/<input\([^>]*[^\/]\)>/<input\1\/>/g'

  " Image hacker
  while search( '<img[^>]*>\(.*$\n\)\+<\/img>', 'ncw')
    silent! exec 'g/<img[^>]*>\(.*$\n\)\+<\/img>/s/\n//g'
  endwhile
  silent! exec '%s/<img/<img/g'
  silent! exec 'g!/<\/img>/s/<img\([^>]*[^\/]\)>/<img\1\/>/g'

  " Meta hacker
  while search( '<meta[^>]*>\(.*$\n\)\+<\/meta>', 'ncw')
    silent! exec 'g/<meta[^>]*>\(.*$\n\)\+<\/meta>/s/\n//g'
  endwhile
  silent! exec '%s/<meta/<meta/g'
  silent! exec 'g!/<\/meta>/s/<meta\([^>]*[^\/]\)>/<meta\1\/>/g'

  " Link hacker
  while search( '<link[^>]*>\(.*$\n\)\+<\/link>', 'ncw')
    silent! exec 'g/<link[^>]*>\(.*$\n\)\+<\/link>/s/\n//g'
  endwhile
  silent! exec '%s/<link/<link/g'
  silent! exec 'g!/<\/link>/s/<link\([^>]*[^\/]\)>/<link\1\/>/g'

  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  $d
  2d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  silent! exec '%s/[<]\(\(td\|a\|textarea\|div\|iframe\|span\)[^>]*\)\/[>]/<\1><\/\2>/g'
  silent! exec '%s/[&]#x[Aa]0;/\&#160;/g'
  silent! exec '%s/[&]#x[Aa]9;/\&#169;/g'

  " Remove the new lines hacker
  while search( '\n\n', 'ncw')
    silent! exec '%s/\n\n//g'
  endwhile

  1d
  1
  silent! exec 's/<!-- \(DOCTYPE.\{-}\) -->/<!\1>/'

  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! StripHTML call DoStripHTML()

function! DoStripIt()

  " Things that need fixin
  "
  silent! exec '%s///g'
  1
  silent! exec '%s/\(<\/\?[a-zA-Z]*\)/\L\1/g'
  silent! exec '%s/[&]nbsp;/\&#160;/g'
  silent! exec '%s/[&]copy;/\&#169;/g'
  silent! exec '%s/\(<br[^\/>]*\)>/\1\/>/g'
  silent! exec '%s/href="https\?:\/\/[^"]*"/href="#"/g'

  " Script hacker
  while search( '<script[^>]*>\(.*$\n\)\+<\/script>', 'ncw')
    silent! exec 'g/<script[^>]*>\(.*$\n\)\+<\/script>/s/\n//g'
  endwhile
  silent! exec '%s/<script.\{-}<\/script>//g'

  " Tag hacker
  while search( '<[^>]*$\n', 'ncw')
    silent! exec 'g/<[^>]*$\n/s/\s*$\n\s*/ /g'
  endwhile

  while search( '<[a-z][^>]\+ on[a-zA-Z]\+=[''"][a-zA-Z]\+([^)]\+.\{-});\?', 'ncw')
     silent! exec '%s/\(<[a-z][^>]\+\) \(on[a-zA-Z]\+\)=[''"]\([a-zA-Z]\+\)([^)]\+.\{-});\?[''"]\s*\([^>]*>\)/\1 \L\2=\E"\3();" \4/g'
  endwhile

  while search( '<[a-z][^>]\+ on[a-zA-Z]\+=[a-zA-Z]\+([^)]\+.\{-});\? \?', 'ncw')
     silent! exec '%s/\(<[a-z][^>]\+\) \(on[a-zA-Z]\+\)=\([a-zA-Z]\+\)([^)]\+.\{-});\? \?\([^>]*>\)/\1 \L\2=\E"\3();" \4/g'
  endwhile

  " Attribute hacker
  while search( '<[a-z][^>]\+ [a-zA-Z]\+ [^>]*>', 'ncw')
    silent! exec '%s/\(<[a-z][^>]\+\) \([a-zA-Z]\+\) \([^>]*>\)/\1 \L\2="\2"\E \3/g'
  endwhile

  1

endfunction
command! StripIt call DoStripIt()


function! CygwinCopy()
  if has('win32unix')
    let l:file = '/dev/clipboard'
  else
    let l:file = $HOME . '/.clipboard'
  endif
  call writefile( split(substitute(@@, "\n", "\r\n", 'g'), "\x0A", 1), l:file, 'b')
endfunction
command! Copy call CygwinCopy()
command! Clip call CygwinCopy()

function! CygwinPaste()
  if has('win32unix')
    let l:file = '/dev/clipboard'
  else
    let l:file = $HOME . '/.clipboard'
  endif
  let l:contents = ''
  for l:line in readfile(l:file, 'b')
    let l:contents = l:contents . "\n" . substitute(l:line, "\r", '', 'g')
  endfor
  let @@ = l:contents
  exec "normal! p"
endfunction
command! Paste call CygwinPaste()
command! Pop call CygwinPaste()


function! SwapTicQuote()
  let l:saved_reg = @"

  exec "normal! yl"
  if @" == '"'
    exec "normal! r'"
    exec "normal /\"\<CR>"
  elseif @" == "'"
    exec "normal! r\""
    exec "normal /'\<CR>"
  else
    exec "normal! l"
  endif

  let @" = l:saved_reg
endfunction
noremap <silent> ! <Esc>:call SwapTicQuote()<CR>

function! JoinHtmlLine()
  let l:saved_reg = @"

  exec "normal! Jlylh"
  if @" == '<'
    exec "normal! hyll"
    if @" == '>'
      exec "normal! x"
    endif
  endif

  let @" = l:saved_reg
endfunction
noremap <silent> + <Esc>:call JoinHtmlLine()<CR>


"" Per file mappings
 "  Note: No spaces after commas on file list
 "  example
 "   *.java - all java files
 "   call MapJava() - runs function MapJava
 "   fun MapJava() - start of function
 "    . . .
 "   endfun - end of function
""
au BufNewFile,BufRead *.xml call MapXML()
fun MapXML()
  set syntax=xml
  set ts=2
  set sts=2
  set sw=2
  map! <C-]> <Esc>I<Home><!-- <Esc>A --><Esc>j<Home>
  map <C-]> <Esc>I<Home><!-- <Esc>A --><Esc>j<Home>
  set omnifunc=xmlcomplete#CompleteTags
endfun

au BufNewFile,BufRead *.pm,*.bat,*.pl call MapPL()
fun MapPL()
  set syntax=perl
  set ts=2
  set sts=2
  set sw=2
  map! <C-]> <Esc>I<Home>#<Esc>j<Home>
  map <C-]> <Esc>I<Home>#<Esc>j<Home>
endfun

au BufNewFile,BufRead *.py call MapPY()
fun MapPY()
  set syntax=python
  set ts=2
  set sts=2
  set sw=2
  set et
  map! <C-]> <Esc>I<Home>#<Esc>j<Home>
  map <C-]> <Esc>I<Home>#<Esc>j<Home>
  set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
  set omnifunc=pythoncomplete#Complete
endfun

au BufNewFile,BufRead *.php,*.phtml,*.inc call MapPHP()
fun MapPHP()
  set syntax=php
  set ts=2
  set sts=2
  set sw=2

  map! <C-p><C-p> <?=   ?><Left><Left><Left><Left>
  map! <C-o><C-p> /**<CR><Tab>* <CR>*<CR>* @params ...<CR>*<CR>* @returns ???<CR>*<CR>*/<Esc>6kA
  set omnifunc=phpcomplete#CompletePHP
endfun

au BufNewFile,BufRead *.c call MapC()
fun MapC()
  map! <C-]> <Esc>I<Home>//<Esc>j<Home>
  map <C-]> <Esc>I<Home>//<Esc>j<Home>
endfun

au BufNewFile,BufRead *.java call MapJava()
fun MapJava()
  set syntax=java
  map! sout System.out.println
  map! serr System.err.println
  map! dotca try<CR>{<CR>}<CR>catch ( )<CR>{<CR>}<ESC>kkkko
  map! dotcf try<CR>{<CR>}<CR>catch (Exception e)<CR>{<CR>e.printStackTrace(System.err);<CR>}<ESC><<A<CR>finally<CR>{<CR>}<ESC>kkkkkkkko
  map! <C-]> <Esc>I<Home>//<Esc>j<Home>
  map <C-]> <Esc>I<Home>//<Esc>j<Home>
endfun

au BufNewFile,BufRead *.tex call MapTex()
fun MapTex()
  map ! :w<CR> laTexit all.tex<CR>
  map! doen \begin{enumerate}[1. ]<CR>item{}<CR>\end{enumerate}<ESC>OA<ESC>OD
  map! doit \begin{itemize}<CR>\item{}<CR>\end{itemize}<ESC>OA<ESC>OD
  map! doeq \rb<CR>\begin{equation*}<CR><CR>\end{equation*}<ESC>OA
  map! doal \rb<CR>\begin{align*}<CR><CR>\end{align*}<ESC>OA
  map! dovb \begin{verbatim}<CR><CR>\end{verbatim}<ESC>OA
  map! doga \begin{gather*}<CR><CR>\end{gather*}<ESC>OA
  map! docom \begin{comment}<CR><CR>\end{comment}<ESC>OA
  map! dogr \begin{center}<CR>\begin{picture}(80,40)(-30,-10)<CR>put(-30,-10){\framebox(80,40){}}<CR><CR>\node[Nh=10,Nw=10,Nmr=10,Nmarks=i](0)(-5,10){$q_0$}<CR>\node[Nh=10,Nw=10,Nmr=10,Nmarks=r](1)(25,10){$q_1$}<CR><CR>\drawedge[curvedepth=8](0,1){$\la$}<CR>\drawedge[curvedepth=8](1,0){$\la$}<CR>\drawloop[loopangle=270](0){$\la$}<CR>\drawloop[loopangle=90](1){$\la$}<CR><CR><BS><BS>end{picture}<CR>\end{center}<CR><CR><ESC>
  map! dotab \begin{center}<CR>\begin{tabular}{lll}<CR><CR>\end{tabular}<CR>\end{center}<CR><ESC>OA<ESC>OA<ESC>OA    &    &   \\<ESC>
  map! <C-]> <Esc>I<Home>%<Esc>j<Home>
  map <C-]> <Esc>I<Home>%<Esc>j<Home>
endfun

au BufNewFile,BufRead .exrc,.vimrc,exrc,vimrc,*.func,*vimperatorrc* call MapRC()
fun MapRC()
  setf vim
  set ts=2
  set sts=2
  set sw=2
  set et
  map! <C-]> <Esc>I<Home>" <Esc>j<Home>
  map <C-]> <Esc>I<Home>" <Esc>j<Home>
endfun

au BufNewFile,BufRead .cshrc,cshrc call MapCSHRC()
fun MapCSHRC()
  setf tcsh
  set syntax=tcsh
  set ts=2
  set sts=2
  set sw=2
  set et
endfun

au BufNewFile,BufRead *.js,*.jsx,*.coffee call MapJS()
fun MapJS()
  set syntax=javascript
  set ts=2
  set sts=2
  set sw=2

  map! <C-]> <Esc>I<Home>//<Esc>j<Home>
  map <C-]> <Esc>I<Home>//<Esc>j<Home>
  set omnifunc=javascriptcomplete#CompleteJS
endfun

au BufNewFile,BufRead *.css call MapCSS()
fun MapCSS()
  set syntax=css
  set ts=2
  set sts=2
  set sw=2

  map! <C-]> <Esc>I<Home>/* <Esc>A */<Esc>j<Home>
  map <C-]> <Esc>I<Home>/* <Esc>A */<Esc>j<Home>
  set omnifunc=csscomplete#CompleteCSS
endfun

au BufNewFile,BufRead *.sass call MapSass()
fun MapSass()
  set syntax=sass
  set ts=2
  set sts=2
  set sw=2

  map! <C-]> <Esc>I<Home>/* <Esc>A */<Esc>j<Home>
  map <C-]> <Esc>I<Home>/* <Esc>A */<Esc>j<Home>
  set omnifunc=csscomplete#CompleteCSS
endfun

au BufNewFile,BufRead *.sql call MapSQL()
fun MapSQL()
  set syntax=sql
  set ts=2
  set sts=2
  set sw=2
  map! <C-]> <Esc>I<Home>--<Esc>j<Home>
  map <C-]> <Esc>I<Home>--<Esc>j<Home>
endfun

au BufNewFile,BufRead *.mhtm call MapMustache()
fun MapMustache()
  set syntax=mustache
  set ts=2
  set sts=2
  set sw=2
  set noet

  map! <C-]> <Esc>I<Home><!-- <Esc>A --><Esc>j<Home>
  map <C-]> <Esc>I<Home><!-- <Esc>A --><Esc>j<Home>
  set omnifunc=xmlcomplete#CompleteTags
endfun

au BufNewFile,BufRead *.haml call MapHaml()
fun MapHaml()
  set syntax=haml
  set ts=2
  set sts=2
  set sw=2

  map! <C-]> <Esc>I<Home>-#<Esc>j<Home>
  map <C-]> <Esc>I<Home>-#<Esc>j<Home>
  set omnifunc=xmlcomplete#CompleteTags
endfun

au BufNewFile,BufRead *.htm,*.html,*.tmp call MapHTML()
fun MapHTML()
  " if this is a PHP file
  let l:firstline = getline(1)
  if (l:firstline =~ '<?')
    call MapPHP()
    return
  endif

  set ts=2
  set sts=2
  set sw=2


  map! <C-]> <Esc>I<Home><!-- <Esc>A --><Esc>j<Home>
  map <C-]> <Esc>I<Home><!-- <Esc>A --><Esc>j<Home>
  set omnifunc=xmlcomplete#CompleteTags
endfun

au BufNewFile,BufRead *.asp,*.vbs call MapASP()
fun MapASP()
  set syntax=aspvbs
  set ts=2
  set sts=2
  set sw=2
  map! <C-]> <Esc>I<Home>'<Esc>j<Home>
  map <C-]> <Esc>I<Home>'<Esc>j<Home>
endfun

au BufNewFile,BufRead *.txt call MapTXT()
fun MapTXT()
  set syntax=txt
endfun

" From http://www.perlmonks.org/?node_id=540411
function! CurrSubName()
  let g:subname = repeat(' ', 80)
  let g:subrecurssion = 0

  if (&syntax == 'perl')
    call GetSubName(line('.'), 'sub')
  elseif (&syntax == 'php')
    call GetSubName(line('.'), 'function')
  elseif (&syntax == 'python')
    call GetSubName(line('.'), 'def')
  endif

  return g:subname
endfunction

function! GetSubName(line, fxname)
  let l:str = getline(a:line)

  if l:str =~ '^\s*' . a:fxname
    let l:str = substitute(l:str, '^\s*'. a:fxname .'\s*\(.\{-}\)\s*[:{]\?\s*$', ': \1', '')
    let g:subname = l:str
    return 1
  elseif a:line > 2 && g:subrecurssion < (&maxfuncdepth-2)
    let g:subrecurssion = g:subrecurssion + 1
    return GetSubName((a:line-1), a:fxname)
  endif

  " nothing
  let g:subname = repeat(' ', 80)
  return -1
endfunction

filetype plugin on " help
syntax enable   " enable syntax coloring
syntax on       " turn syntax coloring  on

let g:miniBufExplForceSyntaxEnable = 1

" syntax colors
hi Comment      term=bold cterm=NONE ctermfg=DarkGreen ctermbg=NONE gui=NONE guifg=Blue guibg=NONE
hi Constant     term=underline cterm=NONE ctermfg=DarkRed ctermbg=NONE gui=NONE guifg=Magenta guibg=NONE
hi Special      term=bold cterm=NONE ctermfg=DarkMagenta ctermbg=NONE gui=NONE guifg=SlateBlue guibg=NONE
hi Identifier   term=bold cterm=NONE ctermfg=Black ctermbg=NONE gui=NONE guifg=DarkCyan guibg=NONE
hi Statement    term=bold cterm=NONE ctermfg=DarkBlue ctermbg=NONE gui=bold guifg=Brown guibg=NONE
hi PreProc      term=underline cterm=NONE ctermfg=DarkMagenta ctermbg=NONE gui=NONE guifg=Purple guibg=NONE
hi Type         term=underline cterm=NONE ctermfg=DarkBlue ctermbg=NONE gui=bold guifg=SeaGreen guibg=NONE
hi Underlined   term=underline cterm=underline ctermfg=DarkMagenta gui=underline guifg=SlateBlue
hi Ignore       term=NONE cterm=NONE ctermfg=White ctermbg=NONE gui=NONE guifg=bg guibg=NONE
hi Ignore       term=NONE cterm=NONE ctermfg=White ctermbg=NONE gui=NONE guifg=bg guibg=NONE
hi LineNr       term=NONE cterm=NONE ctermfg=Brown ctermbg=NONE gui=NONE guifg=Brown guibg=NONE

hi NonText      term=NONE cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
hi clear SpecialKey
hi link SpecialKey NonText

hi htmlBoldUnderlineItalic term=bold,underline cterm=bold,underline ctermfg=Brown gui=bold,underline guifg=NONE
hi htmlUnderlineItalic term=underline cterm=underline ctermfg=Brown gui=underline guifg=NONE
hi htmlItalic term=NONE cterm=NONE ctermfg=Brown gui=NONE guifg=NONE

