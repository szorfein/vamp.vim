" =============================================================================
" Filename: autoload/lightline/colorscheme/vamp.vim
" Author: szorfein
" License: MIT License
" Last Change: 2020/04/18
" =============================================================================

let s:black    = g:vamp#palette.bg
let s:gray     = g:vamp#palette.selection
let s:white    = g:vamp#palette.fg
let s:darkblue = g:vamp#palette.comment
let s:cyan     = g:vamp#palette.cyan
let s:green    = g:vamp#palette.green
let s:orange   = g:vamp#palette.orange
let s:purple   = g:vamp#palette.purple
let s:red      = g:vamp#palette.red
let s:yellow   = g:vamp#palette.yellow
let s:pink     = g:vamp#palette.pink

if exists('g:lightline')

  let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
  let s:p.normal.left = [ [ s:black, s:darkblue ], [ s:cyan, s:gray ] ]
  let s:p.normal.right = [ [ s:pink, s:gray ], [ s:purple, s:black ] ]
  let s:p.inactive.right = [ [ s:black, s:darkblue ], [ s:white, s:black ] ]
  let s:p.inactive.left =  [ [ s:cyan, s:black ], [ s:white, s:black ] ]
  let s:p.insert.left = [ [ s:black, s:green ], [ s:cyan, s:gray ] ]
  let s:p.replace.left = [ [ s:black, s:red ], [ s:cyan, s:gray ] ]
  let s:p.visual.left = [ [ s:black, s:orange ], [ s:cyan, s:gray ] ]
  let s:p.normal.middle = [ [ s:white, s:black ] ]
  let s:p.inactive.middle = [ [ s:white, s:gray ] ]
  let s:p.tabline.left = [ [ s:darkblue, s:gray ] ]
  let s:p.tabline.tabsel = [ [ s:pink, s:gray ] ]
  let s:p.tabline.middle = [ [ s:darkblue, s:black ] ]
  let s:p.tabline.right = copy(s:p.normal.right)
  let s:p.normal.error = [ [ s:red, s:black ] ]
  let s:p.normal.warning = [ [ s:yellow, s:black ] ]

  let g:lightline#colorscheme#vamp#palette = lightline#colorscheme#flatten(s:p)

endif

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0:
