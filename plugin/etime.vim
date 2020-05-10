" buffer open
function! EtimeOpen()
  let b:time_open = system('date +%s')
  let b:time_edited = system('getfattr --absolute-names --only-values -n user.etime ' . expand('%'))
  let b:write_count = system('getfattr --absolute-names --only-values -n user.ecount ' . expand('%'))

  if v:shell_error > 0
    let b:time_edited = 0
    let b:write_count = 0
  endif
endfunction

autocmd BufReadPost,BufNewFile * :call EtimeOpen()

" buffer renamed with :sav
function! EtimeRename()
  let b:time_open = system('date +%s')
  let b:time_edited = 0
  let b:write_count = 0
endfunction

autocmd BufFilePost * :call EtimeRename()

" buffer written
function! EtimeWrite()
  if !exists('b:write_count')
    let b:time_open = system('date +%s')
    let b:time_edited = 0
    let b:write_count = 0
  endif

  let b:time_close = system('date +%s')
  let b:time_delta = b:time_close - b:time_open

  call system('setfattr -n user.etime -v ' . (b:time_edited + b:time_delta) . ' ' . expand('%'))

  let b:time_edited += b:time_delta
  let b:time_open = b:time_close
  let b:write_count += 1

  call system('setfattr -n user.ecount -v ' . (b:write_count) . ' ' . expand('%'))
endfunction

autocmd BufWritePost * :call EtimeWrite()
