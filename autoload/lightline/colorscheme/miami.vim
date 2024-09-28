" =============================================================================
" Filename: autoload/lightline/colorscheme/miami.vim
" Author: szorfein based on adamalbrecht
" License: MIT License
" Last Change: 2018/04/11
" =============================================================================

let s:black    = g:miami#palette.bg
let s:gray     = g:miami#palette.bglight
let s:white    = g:miami#palette.fg
let s:blue     = g:miami#palette.secondarycontainer
let s:onblue   = g:miami#palette.onsecondarycontainer
let s:cyan     = g:miami#palette.cyan
let s:orange   = g:miami#palette.tertiarycontainer
let s:onorange = g:miami#palette.ontertiarycontainer
let s:purple   = g:miami#palette.primarycontainer
let s:onpurple = g:miami#palette.onprimarycontainer
let s:red      = g:miami#palette.errorcontainer
let s:onred    = g:miami#palette.onerrorcontainer
let s:yellow   = g:miami#palette.yellow

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

  let g:lightline#colorscheme#miami#palette = lightline#colorscheme#flatten(s:p)
endif

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0:
