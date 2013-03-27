" Execute XQuery Blocks
function! Xq_getVisualBlock() range
    let save = @"
    " Mark the current line to return to
    let curline     = line("'>")
    let curcol      = virtcol("'>")

    silent normal gvy
    let vis_cmd = @"
    let @" = save

    " Return to previous location
    " Accounting for beginning of the line
    call cursor(curline, curcol)

    return vis_cmd
endfunction

function! Xq_execQuery(str)
  exec '!echo -n '.shellescape(a:str).' | xquery -q:- '
endfunction

command! -nargs=0 -range XqExecQuery :call Xq_execQuery(Xq_getVisualBlock())
map <leader>xe :XqExecQuery<cr>
