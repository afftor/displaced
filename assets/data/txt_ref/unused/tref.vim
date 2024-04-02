" Vim syntax file
" Language: Novell Txt Ref
" Maintainer: mintyleaf
" Latest Revision: 8 November 2020

if exists("b:current_syntax")
  finish
endif

set nowrap

syn match someJson '^{.*}'
syn match undefShit '^UD.*)'
syn match title '^\*\*.*\*\*'
syn match comment '^#.*$'
syn match someSyn '^=.*=$'

let b:current_syntax = "txtref"

hi def link someJson Comment
hi def link comment Comment
hi def link undefShit Todo
hi def link title Statement
hi def link someSyn Constant
