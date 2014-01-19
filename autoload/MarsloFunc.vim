func! MarsloFunc#OpenCMD()
  if has('win32') || has('win95') || has('win64')
    if 'java' == &filetype
      let com = '!cmd /c start "C:\Program Files\JPSoft\TCCLE13x64\tcc.exe" /d "' . expand('%:p:h') .'"'
    else
      let com = '!cmd /c start C:\Marslo\Tools\Software\System\CommandLine\Console2\Console.exe -d "'. expand('%:p:h') . '"'
    endif
  else
    let com = '!/usr/bin/gnome-terminal --working-directory=' . expand('%:p:h')
  endif
  let saveit = ':w!'
  echo 'Goto "' . expand('%:p:h') . '" in command line'
  silent execute saveit
  silent execute com
endfunc
nmap cmd :call MarsloFunc#OpenCMD()<CR>

func! MarsloFunc#OpenFoler()
  let folderpath = expand('%:p:h')
  if has('win32') || has('win95') || has('win64')
    silent execute '!C:\Windows\explorer.exe "' . folderpath . '"'
  else
    silent execute '!nautilus "' . folderpath . '"'
  endif
endfunc
map <M-o> :call MarsloFunc#OpenFoler()<CR>

func! MarsloFunc#GetVundle()                                                   " GetVundle() inspired by: http://pastebin.com/embed_iframe.php?i=C9fUE0M3
  let vundleAlreadyExists=1
  if has('win32') || has('win64')
    let bud='$VIM\bundle'
    let vud=bud . '\vundle'
    let vudcfg=expand(vud . '\.git\config')
  else
    let bud='~/.vim/bundle'
    let vud=bud . '/vundle'
    let vudcfg=expand(vud . '/.git/config')
  endif
  if filereadable(vudcfg)
    echo "Vundle has existed at " . expand(vud)
  else
    echo "Installing Vundle..."
    echo ""
    if isdirectory(expand(bud)) == 0
      call mkdir(expand(bud), 'p')
    endif
    execute 'silent !git clone https://github.com/gmarik/vundle.git "' . expand(vud) . '"'
    let vundleAlreadyExists=0
  endif
endfunc
command! GetVundle :call MarsloFunc#GetVundle()

func! MarsloFunc#GetVim()                                                      " Get vim from: git clone git@github.com:b4winckler/vim.git
  if has('unix')
    let vimsrc='~/.vim/vimsrc'
    let vimgitcfg=expand(vimsrc . '/.git/config')
    if filereadable(vimgitcfg)
      echo 'vimsrc has exists at ' . expand(vimsrc)
    else
      execute 'silent !git clone git@github.com:b4winckler/vim.git "' . expand(vimsrc) . '"'
    end
  endif
endfunc
command! GetVim :call MarsloFunc#GetVim()

func! MarsloFunc#RunResult()
  let mp = &makeprg
  let ef = &errorformat
  let exeFile = expand("%:t")
  exec "w"
  if "python" == &filetype
    setlocal makeprg=python\ -u
  elseif "perl" == &filetype
    setlocal makeprg=perl
  elseif "ruby" == &filetype
    setlocal makeprg=ruby
  elseif "autohotkey" == &filetype
    setlocal makeprg=AutoHotkey
  endif
  set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
  silent make %
  copen
  let &makeprg     = mp
  let &errorformat = ef
endfunc

function! MarsloFunc#GotoFile()                                                " Add suffix '.py' if the filetype is python
  if 'python' == &filetype
    let com = expand('%:p:h') . '\' . expand('<cfile>') . '.py'
  else
    let com = expand('<cfile>')
  endif
  silent execute ':e ' . com
  echo 'Open file "' . com . '" under the cursor'
endfunction
nmap gf :call MarsloFunc#GotoFile()<CR>

function! MarsloFunc#UpdateTags()                                              " Update tags file automatic
  silent !ctags -R --fields=+ianS --extra=+q
endfunction
nmap <F12> :call MarsloFunc#UpdateTags()<CR>

if has('gui_running')
  function! <SID>MarsloFunc#FontSize_Reduce()                                  " Reduce the font
    if has('unix')
      let pattern = '\<\d\+$'
    elseif has('win32') || has('win95') || has('win64')
      let pattern = ':h\zs\d\+\ze:'
    endif
    let fontsize = matchstr(&gfn, pattern)
    echo fontsize
    let cmd = substitute(&gfn, pattern, string(fontsize - 1), 'g')
    let &gfn=cmd
  endfunction
  nnoremap <A--> :call <SID>MarsloFunc#FontSize_Reduce()<CR>

  function! <SID>MarsloFunc#FontSize_Enlarge()                                 " Enlarge the font
    if has('unix')
      let pattern = '\<\d\+$'
    elseif has('win32') || has('win95') || has('win64')
      let pattern = ':h\zs\d\+\ze:'
    endif
    let fontsize = matchstr(&gfn, pattern)
    let cmd = substitute(&gfn, pattern, string(fontsize + 1), 'g')
    let &gfn=cmd
  endfunction
  nnoremap <A-+> :call <SID>MarsloFunc#FontSize_Enlarge()<CR>
endif

function! MarsloFunc#SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

function! MarsloFunc#ResCur()                                                  " Remember Cursor position in last time, inspired from http://vim.wikia.com/wiki/VimTip80
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction
" augroup resCur
  " autocmd!
  " autocmd BufWinEnter * call ResCur()
" augroup END

func! MarsloFunc@Echo()
  echo 'Done!'
endfunc
