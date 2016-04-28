" Vim syntax file
" Language: SystemC Log File
" Author: Scott Ahrens

if exists("b:current_syntax")
  finish
endif

syn keyword logTags SCV_INFO
syn keyword debugTags DEBUG0 DEBUG1 DEBUG2 DEBUG3 DEBUG4 DEBUG5 DEBUG6 DEBUG7 DEBUG8 DEBUG9 INFO 
syn keyword simulationTags INFO_REGRESS
syn keyword fatalTags FATAL
syn match sourceLine '.*<main>'
syn match debugLoc ':.*:\d\+:'

let b:current_syntax = "cynLog"

hi def link logTags Statement
hi def link sourceLine Statement
hi def link debugTags Type
hi def link debugLoc  Type
hi def link fatalTags ToDo
hi def link simulationTags PreProc
