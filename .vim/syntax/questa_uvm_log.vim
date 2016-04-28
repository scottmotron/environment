" Vim syntax file
" Language: Mentor Questa UVM Log File
" Author: Scott Ahrens

if exists("b:current_syntax")
  finish
endif

syn match infoLines       '# UVM_INFO \S* @ \S*'
syn match warningLines    '# UVM_WARNING \S* @ \S*'
syn match simwarningLines '# \*\* Warning.*'
syn match errorLines      '# UVM_ERROR \S* @ \S*'
syn match fatalLines      '# UVM_FATAL \S* @ \S*'

let b:current_syntax = "questa_uvm_log"

hi def link infoLines        Type
hi def link warningLines     Preproc
hi def link simwarningLines  Preproc
hi def link errorLines       Statement
hi def link fatalLines       ToDo
