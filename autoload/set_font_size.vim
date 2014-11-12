" Copyright (c) 2014 Alexander Heinrich <alxhnr@nudelpost.de> {{{
"
" This software is provided 'as-is', without any express or implied
" warranty. In no event will the authors be held liable for any damages
" arising from the use of this software.
"
" Permission is granted to anyone to use this software for any purpose,
" including commercial applications, and to alter it and redistribute it
" freely, subject to the following restrictions:
"
"    1. The origin of this software must not be misrepresented; you must
"       not claim that you wrote the original software. If you use this
"       software in a product, an acknowledgment in the product
"       documentation would be appreciated but is not required.
"
"    2. Altered source versions must be plainly marked as such, and must
"       not be misrepresented as being the original software.
"
"    3. This notice may not be removed or altered from any source
"       distribution.
" }}}

" This script operates by echoing special escape sequences. These are
" interpreted by the terminal. The variable 's:error_msg' can be set to a
" string, which will cause :SetFontSize to abort with an error message.

if &term =~ '^rxvt-unicode\(-256color\)\?$'
  let s:xrdb_string = system("xrdb -query | grep -i '^urxvt.font:.*$'")
  let s:match = matchlist(s:xrdb_string,
    \ '\v\curxvt\.font:\s*(.*:pixelsize\=)(\d+)')

  if empty(s:match)
    let s:error_msg = 'SetFontSize: unable to query urxvt font settings.'
  else
    let s:initial_size = s:match[2]
    let s:current_size = s:initial_size
    let s:escape_seq_start = '\e]710;xft:DejaVu Sans Mono:pixelsize='
    let s:escape_seq_end = '\007'
    let s:min_size = 6
  endif
elseif !empty(&term)
  execute "let s:error_msg = \"SetFontSize: the terminal '" . &term
    \ . "' is not supported.\""
else
  let s:error_msg = 'SetFontSize: the current terminal is not supported.'
endif

function! set_font_size#set(arg) " {{{
  if exists('s:error_msg')
    echo s:error_msg
    return
  endif

  let l:old_size = s:current_size

  if a:arg =~ '\v^(\+|\-)[0-9]+$'
    let s:current_size += substitute(a:arg, '^+', '', 'g')
  elseif a:arg =~ '^[0-9]\+$'
    let s:current_size = a:arg
  elseif empty(a:arg)
    let s:current_size = s:initial_size
  else
    echo "SetFontSize: invalid argument '" . a:arg . "'"
    return
  endif

  if s:current_size < s:min_size
    let s:current_size = s:min_size
  endif

  execute "silent !echo -en '" . s:escape_seq_start . s:current_size
    \ . s:escape_seq_end . "'"

  if s:current_size == l:old_size
    redraw!
  endif
endfunction " }}}
