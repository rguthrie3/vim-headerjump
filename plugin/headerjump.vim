" Vim plugin for jumping between source, header, and unit test files
" author: Robert Guthrie

let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_headerjump")
    finish
endif
let g:loaded_headerjump = 1

" ===============================================================================
" CONFIG GLOBALS
" ===============================================================================
" Set to print the state at every update (whenever the buffer changes)
" Default: False
if !exists("g:headerjump_print_state")
    let g:headerjump_print_state = 0
endif

" Given the basename, this string shows how to derive the unit test filename (without
" a path).  E.g if the class name is Matrix.cpp and the test is TestMatrix.cpp,
" we set this var to Test%  The % is substituted for the basename
" Default: %Test
if !exists("g:headerjump_utest_convention")
    let g:headerjump_utest_convention = "%Test"
endif


" ===============================================================================
" SCRIPT VARS
" ===============================================================================
" These variables will always contain the absolute path of the current
" source, header, and unit test
let s:source_state = ""
let s:header_state = ""
let s:utest_state = ""
let s:basename_state = ""


" ===============================================================================
" STATE UPDATE FUNCTIONS
" ===============================================================================
" Update the state of the variables storing which files to jump to
" under which circumstances
function! s:SetState()

    " If we aren't editing one of these filetypes, clear the state for consistency
    let ext = expand("%:e")
    if ext != ".h" && ext != ".cpp" && ext != ".hpp"
        call s:ClearState()
    endif

    " Check if the state needs to be updated
    let curr_basename = substitute(expand("%:t:r"), "[tT][eE][sS][tT]", "", "")
    if curr_basename == s:basename_state
        " We don't need to update our current state,
        " the user is still in the same source / header / test
        return
    endif

    " Set the state accordingly
    let pwd = getcwd()
    let s:basename_state = curr_basename
    let s:source_state = findfile(s:BasenameToSource(s:basename_state), pwd. "/**")
    let s:header_state = findfile(s:BasenameToHeader(s:basename_state), pwd . "/**")
    let s:utest_state = findfile(s:BasenameToUTest(s:basename_state), pwd . "/**")

    " If the debug flag is set, print the new state
    if g:headerjump_print_state == 1
        call s:PrintState()
    endif
endfunction

function! s:ClearState()
    let s:source_state = ""
    let s:header_state = ""
    let s:utest_state = ""
    let s:basename_state = ""
endfunction

" Function for debugging
function! s:PrintState()
    echo "Basename: " . s:basename_state
    echo "Source File: " . s:source_state
    echo "Header File: " . s:header_state
    echo "Unit Test File: " . s:utest_state
endfunction

" Functions for transforming the base name into the different needed files.
" These should eventually by configurable by the user
function! s:BasenameToSource(basename)
    return a:basename . ".cpp"
endfunction

function! s:BasenameToHeader(basename)
    return a:basename . ".h"
endfunction

function! s:BasenameToUTest(basename)
    let utest_basename = substitute(g:headerjump_utest_convention, "%", a:basename, "")
    return utest_basename . ".cpp"
endfunction


" ===============================================================================
" COMMANDS
" ===============================================================================
" Update the buffer state whenever we switch files
augroup HeaderjumpUpdates
    autocmd BufReadPost *.cpp,*.c,*.h call s:SetState()
augroup END

command -nargs=0 HeaderjumpSetState call s:SetState() " Force a manual update
command -nargs=0 HeaderjumpPrintState call s:PrintState() " For debugging purposes
" Jump commands
command -nargs=0 HeaderjumpGotoSource exec "e " . s:source_state
command -nargs=0 HeaderjumpGotoHeader exec "e " . s:header_state
command -nargs=0 HeaderjumpGotoUTest exec "e " . s:utest_state

nnoremap <leader>1 :HeaderjumpGotoSource<CR>
nnoremap <leader>2 :HeaderjumpGotoHeader<CR>
nnoremap <leader>3 :HeaderjumpGotoUTest<CR>

let &cpo = s:save_cpo
