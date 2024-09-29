" =============================================================================
" Filename: autoload/lightline/colorscheme/sci.vim
" Author: szorfein based on adamalbrecht
" License: MIT License
" Last Change: 2018/04/11
" =============================================================================

let s:black    = g:sci#palette.bg
let s:gray     = g:sci#palette.bglight
let s:white    = g:sci#palette.fg
let s:blue     = g:sci#palette.secondarycontainer
let s:onblue   = g:sci#palette.onsecondarycontainer
let s:cyan     = g:sci#palette.cyan
let s:orange   = g:sci#palette.tertiarycontainer
let s:onorange = g:sci#palette.ontertiarycontainer
let s:purple   = g:sci#palette.primarycontainer
let s:onpurple = g:sci#palette.onprimarycontainer
let s:red      = g:sci#palette.errorcontainer
let s:onred    = g:sci#palette.onerrorcontainer
let s:yellow   = g:sci#palette.yellow

if exists('g:lightline')
  let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
  let s:p.normal.left = [ [ s:onpurple, s:purple ], [ s:cyan, s:gray ] ]
  let s:p.normal.right = [ [ s:onpurple, s:purple ], [ s:onblue, s:blue ] ]
  let s:p.inactive.right = [ [ s:onblue, s:blue ], [ s:white, s:black ] ]
  let s:p.inactive.left =  [ [ s:cyan, s:black ], [ s:white, s:black ] ]
  let s:p.insert.left = [ [ s:onblue, s:blue ], [ s:cyan, s:gray ] ]
  let s:p.replace.left = [ [ s:onred, s:red ], [ s:cyan, s:gray ] ]
  let s:p.visual.left = [ [ s:onorange, s:orange ], [ s:cyan, s:gray ] ]
  let s:p.normal.middle = [ [ s:white, s:gray ] ]
  let s:p.inactive.middle = [ [ s:white, s:gray ] ]
  let s:p.tabline.left = [ [ s:onblue, s:blue ] ]
  let s:p.tabline.tabsel = [ [ s:cyan, s:black ] ]
  let s:p.tabline.middle = [ [ s:onblue, s:gray ] ]
  let s:p.tabline.right = copy(s:p.normal.right)
  let s:p.normal.error = [ [ s:onred, s:red ] ]
  let s:p.normal.warning = [ [ s:yellow, s:black ] ]

  let g:lightline#colorscheme#sci#palette = lightline#colorscheme#flatten(s:p)
endif

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0:
