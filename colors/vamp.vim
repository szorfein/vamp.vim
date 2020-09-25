" Vamp Theme: {{{
"
" https://github.com/szorfein/vamp.vim
"
scriptencoding utf8
" }}}

" Configuration: {{{

if v:version > 580
  highlight clear
  if exists('syntax_on')
    syntax reset
  endif
endif

let g:colors_name = 'vamp'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" Palette: {{{2

let s:fg        = g:vamp#palette.fg

let s:bglighter = g:vamp#palette.bglighter
let s:bglight   = g:vamp#palette.bglight
let s:bg        = g:vamp#palette.bg
let s:bgdark    = g:vamp#palette.bgdark
let s:bgdarker  = g:vamp#palette.bgdarker

let s:comment   = g:vamp#palette.comment
let s:selection = g:vamp#palette.selection
let s:subtle    = g:vamp#palette.subtle

let s:cyan      = g:vamp#palette.cyan
let s:green     = g:vamp#palette.green
let s:orange    = g:vamp#palette.orange
let s:pink      = g:vamp#palette.pink
let s:purple    = g:vamp#palette.purple
let s:red       = g:vamp#palette.red
let s:yellow    = g:vamp#palette.yellow

let s:none      = ['NONE', 'NONE']

if has('nvim')
  for s:i in range(16)
    let g:terminal_color_{s:i} = g:vamp#palette['color_' . s:i]
  endfor
endif

if has('terminal')
  let g:terminal_ansi_colors = []
  for s:i in range(16)
    call add(g:terminal_ansi_colors, g:vamp#palette['color_' . s:i])
  endfor
endif

" }}}2
" User Configuration: {{{2

if !exists('g:vamp_bold')
  let g:vamp_bold = 1
endif

if !exists('g:vamp_italic')
  let g:vamp_italic = 1
endif

if !exists('g:vamp_underline')
  let g:vamp_underline = 1
endif

if !exists('g:vamp_undercurl') && g:vamp_underline != 0
  let g:vamp_undercurl = 1
endif

if !exists('g:vamp_inverse')
  let g:vamp_inverse = 1
endif

if !exists('g:vamp_colorterm')
  let g:vamp_colorterm = 1
endif

"}}}2
" Script Helpers: {{{2

let s:attrs = {
      \ 'bold': g:vamp_bold == 1 ? 'bold' : 0,
      \ 'italic': g:vamp_italic == 1 ? 'italic' : 0,
      \ 'underline': g:vamp_underline == 1 ? 'underline' : 0,
      \ 'undercurl': g:vamp_undercurl == 1 ? 'undercurl' : 0,
      \ 'inverse': g:vamp_inverse == 1 ? 'inverse' : 0,
      \}

function! s:h(scope, fg, ...) " bg, attr_list, special
  let l:fg = copy(a:fg)
  let l:bg = get(a:, 1, ['NONE', 'NONE'])

  let l:attr_list = filter(get(a:, 2, ['NONE']), 'type(v:val) == 1')
  let l:attrs = len(l:attr_list) > 0 ? join(l:attr_list, ',') : 'NONE'

  " Falls back to coloring foreground group on terminals because
  " nearly all do not support undercurl
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !has('gui_running')
    let l:fg[0] = l:special[0]
    let l:fg[1] = l:special[1]
  endif

  let l:hl_string = [
        \ 'highlight', a:scope,
        \ 'guifg=' . l:fg[0], 'ctermfg=' . l:fg[1],
        \ 'guibg=' . l:bg[0], 'ctermbg=' . l:bg[1],
        \ 'gui=' . l:attrs, 'cterm=' . l:attrs,
        \ 'guisp=' . l:special[0],
        \]

  execute join(l:hl_string, ' ')
endfunction

"}}}2
" Vamp Highlight Groups: {{{2

call s:h('VampBgLight', s:none, s:bglight)
call s:h('VampBgLighter', s:none, s:bglighter)
call s:h('VampBgDark', s:none, s:bgdark)
call s:h('VampBgDarker', s:none, s:bgdarker)

call s:h('VampFg', s:fg)
call s:h('VampFgUnderline', s:fg, s:none, [s:attrs.underline])
call s:h('VampFgBold', s:fg, s:none, [s:attrs.bold])

call s:h('VampComment', s:comment)
call s:h('VampCommentBold', s:comment, s:none, [s:attrs.bold])

call s:h('VampSelection', s:none, s:selection)

call s:h('VampSubtle', s:subtle)

call s:h('VampCyan', s:cyan)
call s:h('VampCyanItalic', s:cyan, s:none, [s:attrs.italic])

call s:h('VampGreen', s:green)
call s:h('VampGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('VampGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('VampGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])

call s:h('VampOrange', s:orange)
call s:h('VampOrangeBold', s:orange, s:none, [s:attrs.bold])
call s:h('VampOrangeItalic', s:orange, s:none, [s:attrs.italic])
call s:h('VampOrangeBoldItalic', s:orange, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('VampOrangeInverse', s:bg, s:orange)

call s:h('VampPink', s:pink)
call s:h('VampPinkItalic', s:pink, s:none, [s:attrs.italic])

call s:h('VampPurple', s:purple)
call s:h('VampPurpleBold', s:purple, s:none, [s:attrs.bold])
call s:h('VampPurpleItalic', s:purple, s:none, [s:attrs.italic])

call s:h('VampRed', s:red)
call s:h('VampRedInverse', s:fg, s:red)

call s:h('VampYellow', s:yellow)
call s:h('VampYellowItalic', s:yellow, s:none, [s:attrs.italic])

call s:h('VampError', s:red, s:none, [], s:red)

call s:h('VampErrorLine', s:none, s:none, [s:attrs.undercurl], s:red)
call s:h('VampWarnLine', s:none, s:none, [s:attrs.undercurl], s:orange)
call s:h('VampInfoLine', s:none, s:none, [s:attrs.undercurl], s:cyan)

call s:h('VampTodo', s:cyan, s:none, [s:attrs.bold, s:attrs.inverse])
call s:h('VampSearch', s:green, s:none, [s:attrs.inverse])
call s:h('VampBoundary', s:comment, s:bgdark)
call s:h('VampLink', s:cyan, s:none, [s:attrs.underline])

call s:h('VampDiffChange', s:orange, s:none)
call s:h('VampDiffText', s:bg, s:orange)
call s:h('VampDiffDelete', s:red, s:bgdark)

" }}}2

" }}}
" User Interface: {{{

set background=dark

" Required as some plugins will overwrite
call s:h('Normal', s:fg, g:vamp_colorterm || has('gui_running') ? s:bg : s:none )
call s:h('StatusLine', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineNC', s:none, s:bglight)
call s:h('StatusLineTerm', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineTermNC', s:none, s:bglight)
call s:h('WildMenu', s:bg, s:purple, [s:attrs.bold])
call s:h('CursorLine', s:none, s:subtle)

hi! link ColorColumn  VampBgDark
hi! link CursorColumn CursorLine
hi! link CursorLineNr VampYellow
hi! link DiffAdd      VampGreen
hi! link DiffAdded    DiffAdd
hi! link DiffChange   VampDiffChange
hi! link DiffDelete   VampDiffDelete
hi! link DiffRemoved  DiffDelete
hi! link DiffText     VampDiffText
hi! link Directory    VampPurpleBold
hi! link ErrorMsg     VampRedInverse
hi! link FoldColumn   VampSubtle
hi! link Folded       VampBoundary
hi! link IncSearch    VampOrangeInverse
hi! link LineNr       VampComment
hi! link MoreMsg      VampFgBold
hi! link NonText      VampSubtle
hi! link Pmenu        VampBgDark
hi! link PmenuSbar    VampBgDark
hi! link PmenuSel     VampSelection
hi! link PmenuThumb   VampSelection
hi! link Question     VampFgBold
hi! link Search       VampSearch
hi! link SignColumn   VampComment
hi! link TabLine      VampBoundary
hi! link TabLineFill  VampBgDarker
hi! link TabLineSel   Normal
hi! link Title        VampGreenBold
hi! link VertSplit    VampBoundary
hi! link Visual       VampSelection
hi! link VisualNOS    Visual
hi! link WarningMsg   VampOrangeInverse

" }}}
" Syntax: {{{

" Required as some plugins will overwrite
call s:h('MatchParen', s:green, s:none, [s:attrs.underline])
call s:h('Conceal', s:cyan, s:none)

" Neovim uses SpecialKey for escape characters only. Vim uses it for that, plus whitespace.
if has('nvim')
  hi! link SpecialKey VampRed
  hi! link LspDiagnosticsUnderline VampFgUnderline
  hi! link LspDiagnosticsInformation VampCyan
  hi! link LspDiagnosticsHint VampCyan
  hi! link LspDiagnosticsError VampError
  hi! link LspDiagnosticsWarning VampOrange
  hi! link LspDiagnosticsUnderlineError VampErrorLine
  hi! link LspDiagnosticsUnderlineHint VampInfoLine
  hi! link LspDiagnosticsUnderlineInformation VampInfoLine
  hi! link LspDiagnosticsUnderlineWarning VampWarnLine
else
  hi! link SpecialKey VampSubtle
endif

hi! link Comment VampComment
hi! link Underlined VampFgUnderline
hi! link Todo VampTodo

hi! link Error VampError
hi! link SpellBad VampErrorLine
hi! link SpellLocal VampWarnLine
hi! link SpellCap VampInfoLine
hi! link SpellRare VampInfoLine

hi! link Constant VampPurple
hi! link String VampYellow
hi! link Character VampPink
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Constant

hi! link Identifier VampFg
hi! link Function VampGreen

hi! link Statement VampPink
hi! link Conditional VampPink
hi! link Repeat VampPink
hi! link Label VampPink
hi! link Operator VampPink
hi! link Keyword VampPink
hi! link Exception VampPink

hi! link PreProc VampPink
hi! link Include VampPink
hi! link Define VampPink
hi! link Macro VampPink
hi! link PreCondit VampPink
hi! link StorageClass VampPink
hi! link Structure VampPink
hi! link Typedef VampPink

hi! link Type VampCyanItalic

hi! link Delimiter VampFg

hi! link Special VampPink
hi! link SpecialComment VampCyanItalic
hi! link Tag VampCyan
hi! link helpHyperTextJump VampLink
hi! link helpCommand VampPurple
hi! link helpExample VampGreen
hi! link helpBacktick Special

"}}}

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0 et:
