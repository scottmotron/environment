if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufNewFile,BufRead *.sclog setf SCLog
  au! BufNewFile,BufRead sim.log setf questa_uvm_log
  au! BufNewFile,BufRead *.ftl setf ftl.vim
augroup END
