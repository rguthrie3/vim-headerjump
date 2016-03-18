" Vim plugin for jumping between source, header, and unit test files
" author: Robert Guthrie

let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_headerjump")
    finish
endif
let g:loaded_headerjump = 1



" These variables will always contain the absolute path of the current
" source, header, and unit test
let s:source_state = ""
let s:header_state = ""
let s:utest_state = ""
let s:basename_state = ""


" Update the state of the variables storing which files to jump to
" under which circumstances
function! s:SetBuffers()
    let curr_basename = expand("%:t:r")
    if curr_basename == s:basename_state
        " We don't need to update our current state,
        " the user is still in the same source / header / test
        return
    endif
    let pwd = getcwd()
    let s:basename_state = substitute(curr_basename, "[tT][eE][sS][tT]", "", "")
    let s:source_state = findfile(s:BasenameToSource(s:basename_state), pwd. "/**")
    let s:header_state = findfile(s:BasenameToHeader(s:basename_state), pwd . "/**")
    let s:utest_state = findfile(s:BasenameToUTest(s:basename_state), pwd . "/**")
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
    return a:basename . "Test.cpp"
endfunction

function! s:PrintState()
    echo s:basename_state
    echo s:source_state
    echo s:header_state
    echo s:utest_state
endfunction

command -nargs=0 HeaderjumpSetBuffers call s:SetBuffers()
command -nargs=0 HeaderjumpGotoHeader exec "e " . s:header_state
command -nargs=0 HeaderjumpPrintState call s:PrintState()

let &cpo = s:save_cpo
