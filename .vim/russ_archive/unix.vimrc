" TO-DO:
"  Add or find:
"    block-insert/copy/paste
"    single-char close-file w/o quit

" Enable VIM features that aren't in VI
set nocompatible

" ------- Scrolling -------
" Map <Ctrl-Down> and <Ctrl-Up> to scroll up and down. This has do be done
" before sourcing mswin.vim because that remaps the {rhs} of the map commands
:nnoremap <C-Down> <C-E>
:vnoremap <C-Down> <C-E>
:inoremap <C-Down> <C-X><C-E>
:noremap <C-Up> <C-Y>
:vnoremap <C-Up> <C-Y>
:inoremap <C-Up> <C-X><C-Y>

" -------- Visual stuff ----------
if !has("unix") && has("gui_running")
  " Use a non-hideous font
  "set guifont=-microsoft-consolas-medium-r-normal-*-*-120-*-*-m-*-microsoft-cp1252 
  set gfn=Consolas:h12:cANSI
  " keep swap files on local drive to avoid "Delayed Write Failed" errors
  set dir=c:\\temp
endif
if has("unix") && has("gui_running")
  " Use a non-hideous font
  set guifont="Consolas 12"
  "set guifont=-adobe-courier-medium-r-normal-*-*-140-*-*-m-*-iso10646-1
endif
if has("gui_running")
  " Set window height to 45 lines of text
  :set lines=45 columns=120
endif
" Use a non-hideous color scheme
"  from: http://vim.sourceforge.net/scripts/script.php?script_id=760
colorscheme ps_color
" Let block-select mode include non-existant characters
set virtualedit=block
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch

  " Make F5 toggle highlight mode (to turn it off after a search)
  map <F5> :set hls!<bar>set hls?<CR>

  " Turn highliting back on for the next search
  nnoremap / :set hlsearch<CR>/
  nnoremap * :set hlsearch<CR>*
endif

" Set folding options
if has("folding")
  " see http://www.linux.com/archive/feature/114138 for tips

  "use markers (curly-braces) instead of side-band
  set foldmethod=marker

  "open & close folds with ctrl-alt-left/right
  nmap <C-A-Right> zo
  nmap <C-A-Left> zc
  inoremap <C-A-Right> <C-O>zo
  inoremap <C-A-Left> <C-O>zc

  "open & close ALL folds with ctrl-alt-down/up
  nmap <C-A-Down> zR
  nmap <C-A-Up> zM
  inoremap <C-A-Down> <C-O>zR
  inoremap <C-A-Up> <C-O>zM
endif

" Make sure to keep at least 6 lines visible above/below the cursor
:set scrolloff=6

" Russ: I'm not really sure what this does
" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " edit ejava vhd and verilog files as vhdl/verilog
  "    see: http://vimdoc.sourceforge.net/htmldoc/filetype.html#new-filetype
  au BufRead,BufNewFile *_vhd.ejava	setfiletype vhdl
  au BufRead,BufNewFile *_v.ejava	setfiletype verilog

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" -------- Editing modes -------
"  This one means you're always in insert-mode, except when you type
"  <Ctrl-O> (for a single command) or <Ctrl-L> for multiple commands. <Esc>
"  returns to insert mode, instead of returning to "normal" mode
"set insertmode

" -------- Network file editing -----
"if !has("unix") && has("gui_running")
  " For Windows, use pscp
"  let g:netrw_scp_cmd  = '"C:\Program Files (x86)\PuTTY\pscp.exe\" -q -batch'
"  let g:netrw_sftp_cmd = '"C:\Program Files (x86)\PuTTY\psftp.exe"'
"  let g:netrw_ssh_cmd = '"C:\Program Files (x86)\PuTTY\plink.exe -ssh"'
"  let g:netrw_scp_cmd  = 'pscp.exe -q -batch'
"  let g:netrw_sftp_cmd = 'psftp.exe'
"  let g:netrw_ssh_cmd = 'plink.exe -ssh'
""endif


" ------- Rectangle-select with mouse -------
noremap <C-LeftMouse> <LeftMouse><Esc><C-Q>
noremap <C-LeftDrag> <LeftDrag>

" ------- Add Windows-like behavior  -------
source $VIMRUNTIME/mswin.vim
" Use C-Tab and C-S-Tab to cycle through buffers
" :nnoremap <C-Tab> :bnext<CR>
" :nnoremap <S-C-Tab> :bprevious<CR>
"
" NOTE: Changed to use tabs. See http://vim.wikia.com/wiki/Using_tab_pages
set tabpagemax=99
if has("gui_running")
  set switchbuf=usetab,newtab
endif
:nnoremap <C-Tab> :sbnext<CR>
:nnoremap <S-C-Tab> :sbprevious<CR>
let notabs = 0
nnoremap <silent> <F8> :let notabs=!notabs<Bar>:if notabs<Bar>:tabo<Bar>:else<Bar>:tab ball<Bar>:tabn<Bar>:endif<CR>

" Tab headings
function GuiTabLabel()
    let label = ''
    let bufnrlist = tabpagebuflist(v:lnum)

    " Add '+' if one of the buffers in the tab page is modified
    for bufnr in bufnrlist
        if getbufvar(bufnr, "&modified")
            let label = '+'
            break
        endif
    endfor

    " Append the number of windows in the tab page if more than one
    let wincount = tabpagewinnr(v:lnum, '$')
    if wincount > 1
        let label .= wincount
    endif
    if label != ''
        let label .= ' '
    endif

    " Append the buffer name (not full path)
    return label . "%t"
endfunction

set guitablabel=%!GuiTabLabel()

" ------- Search stuff -------
" Ignore case when searching
set ignorecase
" Unless I include caps in the search string
set smartcase
" Search as soon as I start typing
set incsearch
" Clear search matches with <Ctrl-N>
nmap <silent> <C-N> :silent noh<CR>

" -------- Multiple buffers/files/whatever ----
" Let me switch between files without having to save first
set hidden

" -------- Other ---------
set undolevels=100     " lots of undo
set history=200        " keep 200 lines of command line history
set ruler              " show the cursor position all the time
"set rulerformat=%20(%l,%c%V%=%5(%p%%%)%)
" default rulerformat=%20(%l,%c%V%=%5(%p%%%)%)  see http://www.linux.com/archive/feature/120126 for some good ideas
" also see:
"      All I care about is if the file format is not unix. If it's not, I want a big red warning. That way I'm not the jerk who checks in a file that causes every line to get modified by the diff patch.
"      So, I added this to my existing statusline:
"        %9*%{&ff=='unix'?'':&ff.'\ format'}%*
"    from: http://vim.wikia.com/wiki/Change_end-of-line_format_for_dos-mac-unix
set showcmd            " display incomplete commands
set expandtab          " use spaces instead of tabs
set tabstop=2
set shiftwidth=2
" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Settings for Align plugin: see http://www.vim.org/scripts/script.php?script_id=294 and
" http://mysite.verizon.net/astronaut/vim/align.html
:nmap ,aa :AlignCtrl =lp1P0|

" ------- Misc shortcuts -----
" source or edit vimrc
:nmap ,s :execute 'source ' .dropboxvimpath . '/vimrc.vim'
:nmap ,v :execute 'e ' .dropboxvimpath . '/vimrc.vim'

" toggle invisibles
:nmap ,l :set list!<CR>

" Search & replace
noremap ;; :%s:::g<Left><Left><Left>

" Search & replace, case-insensitive
noremap ;' :%s:::cg<Left><Left><Left><Left>

" Shortcut to insert a \(\) in search & replace string
cmap ;\ \(\)<Left><Left>

" Make Ctrl-G be find-next in insert mode
inoremap <C-G> <C-O>n

" Remove trailing spaces. ALSO - look at :retab to change tabs to spaces
:nmap _$ :% s_\s\+$__g <CR>
:vmap _$ :  s_\s\+$__g <CR>

:nmap ,r :set textwidth=78 <CR> gqap  " re-flow text to 78 columns

" Using <Shift-Arrow> enters SELECT mode, but just-plain-<Arrow> does not
" exit SELECT mode. This isn't ideal, but it's required for using the <Arrow>
" keys in Visual-Block mode
"set keymodel=startsel

"" I don't know what this is for
"set diffexpr=MyDiff()
"function MyDiff()
"  let opt = '-a --binary '
"  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
"  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
"  let arg1 = v:fname_in
"  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
"  let arg2 = v:fname_new
"  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
"  let arg3 = v:fname_out
"  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
"  let eq = ''
"  if $VIMRUNTIME =~ ' '
"    if &sh =~ '\<cmd'
"      let cmd = '""' . $VIMRUNTIME . '\diff"'
"      let eq = '"'
"    else
"      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
"    endif
"  else
"    let cmd = $VIMRUNTIME . '\diff'
"  endif
"  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
"endfunction

" Enable highlighting of tabs and end-spaces by default - spacehi.vim
" Toggle highlighting of special characters with <F3>
autocmd BufNewFile,BufReadPost,FilterReadPost,FileReadPost,Syntax * SpaceHi
au FileType help NoSpaceHi

" Make F4 toggle NERDTree
" see: http://www.vim.org/scripts/script.php?script_id=1658
" switch between tree & edit window with Ctrl-W w
" ? = get help, o = open/close dir or open file, C = make dir new root
map <F4> :NERDTreeToggle<CR>


" Example of search/replace string to make verilog instance from verilog ports
"320,345s:\(input\)\=\s*\(output\)\=\s*\(reg\)\=\s*\(\[.*\]\)\=\s*\(\S*\),:.\5 (\5),:cg
"
