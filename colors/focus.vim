" Focus Theme: {{{
"
" https://github.com/zenorocha/focus-theme
"
" Copyright 2016, All rights reserved
"
" Code licensed under the MIT license
" http://zenorocha.mit-license.org
"
" @author Trevor Heins <@heinst>
" @author Éverton Ribeiro <nuxlli@gmail.com>
" @author Derek Sifford <dereksifford@gmail.com>
" @author Zeno Rocha <hi@zenorocha.com>
scriptencoding utf8
" }}}

" Configuration: {{{

if v:version > 580
  highlight clear
  if exists('syntax_on')
    syntax reset
  endif
endif

let g:colors_name = 'focus'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" Palette: {{{2

let s:fg        = g:focus#palette.fg

let s:bglighter = g:focus#palette.bglighter
let s:bglight   = g:focus#palette.bglight
let s:bg        = g:focus#palette.bg
let s:bgdark    = g:focus#palette.bgdark
let s:bgdarker  = g:focus#palette.bgdarker

let s:comment   = g:focus#palette.comment
let s:selection = g:focus#palette.selection
let s:subtle    = g:focus#palette.subtle

let s:cyan      = g:focus#palette.cyan
let s:green     = g:focus#palette.green
let s:orange    = g:focus#palette.orange
let s:pink      = g:focus#palette.pink
let s:purple    = g:focus#palette.purple
let s:red       = g:focus#palette.red
let s:yellow    = g:focus#palette.yellow

let s:none      = ['NONE', 'NONE']

if has('nvim')
  for s:i in range(16)
    let g:terminal_color_{s:i} = g:focus#palette['color_' . s:i]
  endfor
endif

if has('terminal')
  let g:terminal_ansi_colors = []
  for s:i in range(16)
    call add(g:terminal_ansi_colors, g:focus#palette['color_' . s:i])
  endfor
endif

" }}}2
" User Configuration: {{{2

if !exists('g:focus_bold')
  let g:focus_bold = 1
endif

if !exists('g:focus_italic')
  let g:focus_italic = 1
endif

if !exists('g:focus_strikethrough')
  let g:focus_strikethrough = 1
endif

if !exists('g:focus_underline')
  let g:focus_underline = 1
endif

if !exists('g:focus_undercurl')
  let g:focus_undercurl = g:focus_underline
endif

if !exists('g:focus_full_special_attrs_support')
  let g:focus_full_special_attrs_support = has('gui_running')
endif

if !exists('g:focus_inverse')
  let g:focus_inverse = 1
endif

if !exists('g:focus_colorterm')
  let g:focus_colorterm = 1
endif

if !exists('g:focus_high_contrast_diff')
  let g:focus_high_contrast_diff = 0
endif

"}}}2
" Script Helpers: {{{2

let s:attrs = {
      \ 'bold': g:focus_bold == 1 ? 'bold' : 0,
      \ 'italic': g:focus_italic == 1 ? 'italic' : 0,
      \ 'strikethrough': g:focus_strikethrough == 1 ? 'strikethrough' : 0,
      \ 'underline': g:focus_underline == 1 ? 'underline' : 0,
      \ 'undercurl': g:focus_undercurl == 1 ? 'undercurl' : 0,
      \ 'inverse': g:focus_inverse == 1 ? 'inverse' : 0,
      \}

function! s:h(scope, fg, ...) " bg, attr_list, special
  let l:fg = copy(a:fg)
  let l:bg = get(a:, 1, ['NONE', 'NONE'])

  let l:attr_list = filter(get(a:, 2, ['NONE']), 'type(v:val) == 1')
  let l:attrs = len(l:attr_list) > 0 ? join(l:attr_list, ',') : 'NONE'

  " If the UI does not have full support for special attributes (like underline and
  " undercurl) and the highlight does not explicitly set the foreground color,
  " make the foreground the same as the attribute color to ensure the user will
  " get some highlight if the attribute is not supported. The default behavior
  " is to assume that terminals do not have full support, but the user can set
  " the global variable `g:focus_full_special_attrs_support` explicitly if the
  " default behavior is not desirable.
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !g:focus_full_special_attrs_support
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
" Focus Highlight Groups: {{{2

call s:h('FocusBgLight', s:none, s:bglight)
call s:h('FocusBgLighter', s:none, s:bglighter)
call s:h('FocusBgDark', s:none, s:bgdark)
call s:h('FocusBgDarker', s:none, s:bgdarker)

call s:h('FocusFg', s:fg)
call s:h('FocusFgUnderline', s:fg, s:none, [s:attrs.underline])
call s:h('FocusFgBold', s:fg, s:none, [s:attrs.bold])
call s:h('FocusFgStrikethrough', s:fg, s:none, [s:attrs.strikethrough])

call s:h('FocusComment', s:comment)
call s:h('FocusCommentBold', s:comment, s:none, [s:attrs.bold])

call s:h('FocusSelection', s:none, s:selection)

call s:h('FocusSubtle', s:subtle)

call s:h('FocusCyan', s:cyan)
call s:h('FocusCyanItalic', s:cyan, s:none, [s:attrs.italic])

call s:h('FocusGreen', s:green)
call s:h('FocusGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('FocusGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('FocusGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])

call s:h('FocusOrange', s:orange)
call s:h('FocusOrangeBold', s:orange, s:none, [s:attrs.bold])
call s:h('FocusOrangeItalic', s:orange, s:none, [s:attrs.italic])
call s:h('FocusOrangeBoldItalic', s:orange, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('FocusOrangeInverse', s:bg, s:orange)

call s:h('FocusPink', s:pink)
call s:h('FocusPinkItalic', s:pink, s:none, [s:attrs.italic])

call s:h('FocusPurple', s:purple)
call s:h('FocusPurpleBold', s:purple, s:none, [s:attrs.bold])
call s:h('FocusPurpleItalic', s:purple, s:none, [s:attrs.italic])

call s:h('FocusRed', s:red)
call s:h('FocusRedInverse', s:fg, s:red)

call s:h('FocusYellow', s:yellow)
call s:h('FocusYellowItalic', s:yellow, s:none, [s:attrs.italic])

call s:h('FocusError', s:red, s:none, [], s:red)

call s:h('FocusErrorLine', s:none, s:none, [s:attrs.undercurl], s:red)
call s:h('FocusWarnLine', s:none, s:none, [s:attrs.undercurl], s:orange)
call s:h('FocusInfoLine', s:none, s:none, [s:attrs.undercurl], s:cyan)

call s:h('FocusTodo', s:cyan, s:none, [s:attrs.bold, s:attrs.inverse])
call s:h('FocusSearch', s:green, s:none, [s:attrs.inverse])
call s:h('FocusBoundary', s:comment, s:bgdark)
call s:h('FocusWinSeparator', s:comment, s:bgdark)
call s:h('FocusLink', s:cyan, s:none, [s:attrs.underline])

if g:focus_high_contrast_diff
  call s:h('FocusDiffChange', s:yellow, s:purple)
  call s:h('FocusDiffDelete', s:bgdark, s:red)
else
  call s:h('FocusDiffChange', s:orange, s:none)
  call s:h('FocusDiffDelete', s:red, s:bgdark)
endif

call s:h('FocusDiffText', s:bg, s:orange)
call s:h('FocusInlayHint', s:comment, s:bgdark)

" }}}2

" }}}
" User Interface: {{{

set background=dark

" Required as some plugins will overwrite
call s:h('Normal', s:fg, g:focus_colorterm || has('gui_running') ? s:bg : s:none )
call s:h('StatusLine', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineNC', s:none, s:bglight)
call s:h('StatusLineTerm', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineTermNC', s:none, s:bglight)
call s:h('WildMenu', s:bg, s:purple, [s:attrs.bold])
call s:h('CursorLine', s:none, s:subtle)

hi! link ColorColumn  FocusBgDark
hi! link CursorColumn CursorLine
hi! link CursorLineNr FocusYellow
hi! link DiffAdd      FocusGreen
hi! link DiffAdded    DiffAdd
hi! link DiffChange   FocusDiffChange
hi! link DiffDelete   FocusDiffDelete
hi! link DiffRemoved  DiffDelete
hi! link DiffText     FocusDiffText
hi! link Directory    FocusPurpleBold
hi! link ErrorMsg     FocusRedInverse
hi! link FoldColumn   FocusSubtle
hi! link Folded       FocusBoundary
hi! link IncSearch    FocusOrangeInverse
call s:h('LineNr', s:comment)
hi! link MoreMsg      FocusFgBold
hi! link NonText      FocusSubtle
hi! link Pmenu        FocusBgDark
hi! link PmenuSbar    FocusBgDark
hi! link PmenuSel     FocusSelection
hi! link PmenuThumb   FocusSelection
call s:h('PmenuMatch', s:cyan, s:bgdark)
call s:h('PmenuMatchSel', s:cyan, s:selection)
hi! link Question     FocusFgBold
hi! link Search       FocusSearch
call s:h('SignColumn', s:comment)
hi! link TabLine      FocusBoundary
hi! link TabLineFill  FocusBgDark
hi! link TabLineSel   Normal
hi! link Title        FocusGreenBold
hi! link VertSplit    FocusWinSeparator
hi! link Visual       FocusSelection
hi! link VisualNOS    Visual
hi! link WarningMsg   FocusOrangeInverse

" }}}
" Syntax: {{{

" Required as some plugins will overwrite
call s:h('MatchParen', s:green, s:none, [s:attrs.underline])
call s:h('Conceal', s:cyan, s:none)

" Neovim uses SpecialKey for escape characters only. Vim uses it for that, plus whitespace.
if has('nvim')
  hi! link SpecialKey FocusRed
  hi! link LspReferenceText FocusSelection
  hi! link LspReferenceRead FocusSelection
  hi! link LspReferenceWrite FocusSelection
  " Link old 'LspDiagnosticsDefault*' hl groups
  " for backward compatibility with neovim v0.5.x
  hi! link LspDiagnosticsDefaultInformation DiagnosticInfo
  hi! link LspDiagnosticsDefaultHint DiagnosticHint
  hi! link LspDiagnosticsDefaultError DiagnosticError
  hi! link LspDiagnosticsDefaultWarning DiagnosticWarn
  hi! link LspDiagnosticsUnderlineError DiagnosticUnderlineError
  hi! link LspDiagnosticsUnderlineHint DiagnosticUnderlineHint
  hi! link LspDiagnosticsUnderlineInformation DiagnosticUnderlineInfo
  hi! link LspDiagnosticsUnderlineWarning DiagnosticUnderlineWarn
  hi! link LspInlayHint FocusInlayHint

  hi! link DiagnosticInfo FocusCyan
  hi! link DiagnosticHint FocusCyan
  hi! link DiagnosticError FocusError
  hi! link DiagnosticWarn FocusOrange
  hi! link DiagnosticUnderlineError FocusErrorLine
  hi! link DiagnosticUnderlineHint FocusInfoLine
  hi! link DiagnosticUnderlineInfo FocusInfoLine
  hi! link DiagnosticUnderlineWarn FocusWarnLine

  hi! link WinSeparator FocusWinSeparator
  hi! link NormalFloat Pmenu

  if has('nvim-0.9')
    hi! link  @lsp.type.class FocusCyan
    hi! link  @lsp.type.decorator FocusGreen
    hi! link  @lsp.type.enum FocusCyan
    hi! link  @lsp.type.enumMember FocusPurple
    hi! link  @lsp.type.function FocusGreen
    hi! link  @lsp.type.interface FocusCyan
    hi! link  @lsp.type.macro FocusCyan
    hi! link  @lsp.type.method FocusGreen
    hi! link  @lsp.type.namespace FocusCyan
    hi! link  @lsp.type.parameter FocusOrangeItalic
    hi! link  @lsp.type.property FocusOrange
    hi! link  @lsp.type.struct FocusCyan
    hi! link  @lsp.type.type FocusCyanItalic
    hi! link  @lsp.type.typeParameter FocusPink
    hi! link  @lsp.type.variable FocusFg
  endif
else
  hi! link SpecialKey FocusPink
endif

hi! link Comment FocusComment
hi! link Underlined FocusFgUnderline
hi! link Todo FocusTodo

hi! link Error FocusError
hi! link SpellBad FocusErrorLine
hi! link SpellLocal FocusWarnLine
hi! link SpellCap FocusInfoLine
hi! link SpellRare FocusInfoLine

hi! link Constant FocusPurple
hi! link String FocusYellow
hi! link Character FocusPink
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Constant

hi! link Identifier FocusFg
hi! link Function FocusGreen

hi! link Statement FocusPink
hi! link Conditional FocusPink
hi! link Repeat FocusPink
hi! link Label FocusPink
hi! link Operator FocusPink
hi! link Keyword FocusPink
hi! link Exception FocusPink

hi! link PreProc FocusPink
hi! link Include FocusPink
hi! link Define FocusPink
hi! link Macro FocusPink
hi! link PreCondit FocusPink
hi! link StorageClass FocusPink
hi! link Structure FocusPink
hi! link Typedef FocusPink

hi! link Type FocusCyanItalic

hi! link Delimiter FocusFg

hi! link Special FocusPink
hi! link SpecialComment FocusCyanItalic
hi! link Tag FocusCyan
hi! link helpHyperTextJump FocusLink
hi! link helpCommand FocusPurple
hi! link helpExample FocusGreen
hi! link helpBacktick Special

" }}}

" Languages: {{{

" CSS: {{{
hi! link cssAttrComma         Delimiter
hi! link cssAttrRegion        FocusPink
hi! link cssAttributeSelector FocusGreenItalic
hi! link cssBraces            Delimiter
hi! link cssFunctionComma     Delimiter
hi! link cssNoise             FocusPink
hi! link cssProp              FocusCyan
hi! link cssPseudoClass       FocusPink
hi! link cssPseudoClassId     FocusGreenItalic
hi! link cssUnitDecorators    FocusPink
hi! link cssVendor            FocusGreenItalic
" }}}

" Git Commit: {{{
" The following two are misnomers. Colors are correct.
hi! link diffFile    FocusGreen
hi! link diffNewFile FocusRed

hi! link diffAdded   FocusGreen
hi! link diffLine    FocusCyanItalic
hi! link diffRemoved FocusRed
" }}}

" HTML: {{{
hi! link htmlTag         FocusFg
hi! link htmlArg         FocusGreenItalic
hi! link htmlTitle       FocusFg
hi! link htmlH1          FocusFg
hi! link htmlSpecialChar FocusPurple
" }}}

" JavaScript: {{{
hi! link javaScriptBraces   Delimiter
hi! link javaScriptNumber   Constant
hi! link javaScriptNull     Constant
hi! link javaScriptFunction Keyword

" pangloss/vim-javascript
hi! link jsArrowFunction           Operator
hi! link jsBuiltins                FocusCyan
hi! link jsClassDefinition         FocusCyan
hi! link jsClassMethodType         Keyword
hi! link jsDestructuringAssignment FocusOrangeItalic
hi! link jsDocParam                FocusOrangeItalic
hi! link jsDocTags                 Keyword
hi! link jsDocType                 Type
hi! link jsDocTypeBrackets         FocusCyan
hi! link jsFuncArgOperator         Operator
hi! link jsFuncArgs                FocusOrangeItalic
hi! link jsFunction                Keyword
hi! link jsNull                    Constant
hi! link jsObjectColon             FocusPink
hi! link jsSuper                   FocusPurpleItalic
hi! link jsTemplateBraces          Special
hi! link jsThis                    FocusPurpleItalic
hi! link jsUndefined               Constant

" maxmellon/vim-jsx-pretty
hi! link jsxTag             Keyword
hi! link jsxTagName         Keyword
hi! link jsxComponentName   Type
hi! link jsxCloseTag        Type
hi! link jsxAttrib          FocusGreenItalic
hi! link jsxCloseString     Identifier
hi! link jsxOpenPunct       Identifier
" }}}

" JSON: {{{
hi! link jsonKeyword      FocusCyan
hi! link jsonKeywordMatch FocusPink
" }}}

" Lua: {{{
hi! link luaFunc  FocusCyan
hi! link luaTable FocusFg

" tbastos/vim-lua
hi! link luaBraces       FocusFg
hi! link luaBuiltIn      Constant
hi! link luaDocTag       Keyword
hi! link luaErrHand      FocusCyan
hi! link luaFuncArgName  FocusOrangeItalic
hi! link luaFuncCall     Function
hi! link luaLocal        Keyword
hi! link luaSpecialTable Constant
hi! link luaSpecialValue FocusCyan
" }}}

" Markdown: {{{
hi! link markdownBlockquote        FocusCyan
hi! link markdownBold              FocusOrangeBold
hi! link markdownBoldItalic        FocusOrangeBoldItalic
hi! link markdownCodeBlock         FocusGreen
hi! link markdownCode              FocusGreen
hi! link markdownCodeDelimiter     FocusGreen
hi! link markdownH1                FocusPurpleBold
hi! link markdownH2                markdownH1
hi! link markdownH3                markdownH1
hi! link markdownH4                markdownH1
hi! link markdownH5                markdownH1
hi! link markdownH6                markdownH1
hi! link markdownHeadingDelimiter  markdownH1
hi! link markdownHeadingRule       markdownH1
hi! link markdownItalic            FocusYellowItalic
hi! link markdownLinkText          FocusPink
hi! link markdownListMarker        FocusCyan
hi! link markdownOrderedListMarker FocusCyan
hi! link markdownRule              FocusComment
hi! link markdownUrl               FocusLink

" plasticboy/vim-markdown
hi! link htmlBold       FocusOrangeBold
hi! link htmlBoldItalic FocusOrangeBoldItalic
hi! link htmlH1         FocusPurpleBold
hi! link htmlItalic     FocusYellowItalic
hi! link mkdBlockquote  FocusYellowItalic
hi! link mkdBold        FocusOrangeBold
hi! link mkdBoldItalic  FocusOrangeBoldItalic
hi! link mkdCode        FocusGreen
hi! link mkdCodeEnd     FocusGreen
hi! link mkdCodeStart   FocusGreen
hi! link mkdHeading     FocusPurpleBold
hi! link mkdInlineUrl   FocusLink
hi! link mkdItalic      FocusYellowItalic
hi! link mkdLink        FocusPink
hi! link mkdListItem    FocusCyan
hi! link mkdRule        FocusComment
hi! link mkdUrl         FocusLink
" }}}

" OCaml: {{{
hi! link ocamlModule  Type
hi! link ocamlModPath Normal
hi! link ocamlLabel   FocusOrangeItalic
" }}}

" Perl: {{{
" Regex
hi! link perlMatchStartEnd       FocusRed

" Builtin functions
hi! link perlOperator            FocusCyan
hi! link perlStatementFiledesc   FocusCyan
hi! link perlStatementFiles      FocusCyan
hi! link perlStatementFlow       FocusCyan
hi! link perlStatementHash       FocusCyan
hi! link perlStatementIOfunc     FocusCyan
hi! link perlStatementIPC        FocusCyan
hi! link perlStatementList       FocusCyan
hi! link perlStatementMisc       FocusCyan
hi! link perlStatementNetwork    FocusCyan
hi! link perlStatementNumeric    FocusCyan
hi! link perlStatementProc       FocusCyan
hi! link perlStatementPword      FocusCyan
hi! link perlStatementRegexp     FocusCyan
hi! link perlStatementScalar     FocusCyan
hi! link perlStatementSocket     FocusCyan
hi! link perlStatementTime       FocusCyan
hi! link perlStatementVector     FocusCyan

" Highlighting for quoting constructs, tied to existing option in vim-perl
if get(g:, 'perl_string_as_statement', 0)
  hi! link perlStringStartEnd FocusRed
endif

" Signatures
hi! link perlSignature           FocusOrangeItalic
hi! link perlSubPrototype        FocusOrangeItalic

" Hash keys
hi! link perlVarSimpleMemberName FocusPurple
" }}}

" PHP: {{{
hi! link phpClass           Type
hi! link phpClasses         Type
hi! link phpDocTags         FocusCyanItalic
hi! link phpFunction        Function
hi! link phpParent          Normal
hi! link phpSpecialFunction FocusCyan
" }}}

" PlantUML: {{{
hi! link plantumlClassPrivate              SpecialKey
hi! link plantumlClassProtected            FocusOrange
hi! link plantumlClassPublic               Function
hi! link plantumlColonLine                 String
hi! link plantumlDirectedOrVerticalArrowLR Constant
hi! link plantumlDirectedOrVerticalArrowRL Constant
hi! link plantumlHorizontalArrow           Constant
hi! link plantumlSkinParamKeyword          FocusCyan
hi! link plantumlTypeKeyword               Keyword
" }}}

" PureScript: {{{
hi! link purescriptModule Type
hi! link purescriptImport FocusCyan
hi! link purescriptImportAs FocusCyan
hi! link purescriptOperator Operator
hi! link purescriptBacktick Operator
" }}}

" Python: {{{
hi! link pythonBuiltinObj    Type
hi! link pythonBuiltinObject Type
hi! link pythonBuiltinType   Type
hi! link pythonClassVar      FocusPurpleItalic
hi! link pythonExClass       Type
hi! link pythonNone          Type
hi! link pythonRun           Comment
" }}}

" reStructuredText: {{{
hi! link rstComment                             Comment
hi! link rstTransition                          Comment
hi! link rstCodeBlock                           FocusGreen
hi! link rstInlineLiteral                       FocusGreen
hi! link rstLiteralBlock                        FocusGreen
hi! link rstQuotedLiteralBlock                  FocusGreen
hi! link rstStandaloneHyperlink                 FocusLink
hi! link rstStrongEmphasis                      FocusOrangeBold
hi! link rstSections                            FocusPurpleBold
hi! link rstEmphasis                            FocusYellowItalic
hi! link rstDirective                           Keyword
hi! link rstSubstitutionDefinition              Keyword
hi! link rstCitation                            String
hi! link rstExDirective                         String
hi! link rstFootnote                            String
hi! link rstCitationReference                   Tag
hi! link rstFootnoteReference                   Tag
hi! link rstHyperLinkReference                  Tag
hi! link rstHyperlinkTarget                     Tag
hi! link rstInlineInternalTargets               Tag
hi! link rstInterpretedTextOrHyperlinkReference Tag
hi! link rstTodo                                Todo
" }}}

" Ruby: {{{
if ! exists('g:ruby_operators')
    let g:ruby_operators=1
endif

hi! link rubyBlockArgument          FocusOrangeItalic
hi! link rubyBlockParameter         FocusOrangeItalic
hi! link rubyCurlyBlock             FocusPink
hi! link rubyGlobalVariable         FocusPurple
hi! link rubyInstanceVariable       FocusPurpleItalic
hi! link rubyInterpolationDelimiter FocusPink
hi! link rubyRegexpDelimiter        FocusRed
hi! link rubyStringDelimiter        FocusYellow
" }}}

" Rust: {{{
hi! link rustCommentLineDoc Comment
" }}}

" Sass: {{{
hi! link sassClass                  cssClassName
hi! link sassClassChar              cssClassNameDot
hi! link sassId                     cssIdentifier
hi! link sassIdChar                 cssIdentifier
hi! link sassInterpolationDelimiter FocusPink
hi! link sassMixinName              Function
hi! link sassProperty               cssProp
hi! link sassVariableAssignment     Operator
" }}}

" Shell: {{{
hi! link shCommandSub NONE
hi! link shEscape     FocusRed
hi! link shParen      NONE
hi! link shParenError NONE
" }}}

" Tex: {{{
hi! link texBeginEndName  FocusOrangeItalic
hi! link texBoldItalStyle FocusOrangeBoldItalic
hi! link texBoldStyle     FocusOrangeBold
hi! link texInputFile     FocusOrangeItalic
hi! link texItalStyle     FocusYellowItalic
hi! link texLigature      FocusPurple
hi! link texMath          FocusPurple
hi! link texMathMatcher   FocusPurple
hi! link texMathSymbol    FocusPurple
hi! link texSpecialChar   FocusPurple
hi! link texSubscripts    FocusPurple
hi! link texTitle         FocusFgBold
" }}}

" Typescript: {{{
hi! link typescriptAliasDeclaration       Type
hi! link typescriptArrayMethod            Function
hi! link typescriptArrowFunc              Operator
hi! link typescriptArrowFuncArg           FocusOrangeItalic
hi! link typescriptAssign                 Operator
hi! link typescriptBOMWindowProp          Constant
hi! link typescriptBinaryOp               Operator
hi! link typescriptBraces                 Delimiter
hi! link typescriptCall                   typescriptArrowFuncArg
hi! link typescriptClassHeritage          Type
hi! link typescriptClassName              Type
hi! link typescriptDateMethod             FocusCyan
hi! link typescriptDateStaticMethod       Function
hi! link typescriptDecorator              FocusGreenItalic
hi! link typescriptDefaultParam           Operator
hi! link typescriptES6SetMethod           FocusCyan
hi! link typescriptEndColons              Delimiter
hi! link typescriptEnum                   Type
hi! link typescriptEnumKeyword            Keyword
hi! link typescriptFuncComma              Delimiter
hi! link typescriptFuncKeyword            Keyword
hi! link typescriptFuncType               FocusOrangeItalic
hi! link typescriptFuncTypeArrow          Operator
hi! link typescriptGlobal                 Type
hi! link typescriptGlobalMethod           FocusCyan
hi! link typescriptGlobalObjects          Type
hi! link typescriptIdentifier             FocusPurpleItalic
hi! link typescriptInterfaceHeritage      Type
hi! link typescriptInterfaceName          Type
hi! link typescriptInterpolationDelimiter Keyword
hi! link typescriptKeywordOp              Keyword
hi! link typescriptLogicSymbols           Operator
hi! link typescriptMember                 Identifier
hi! link typescriptMemberOptionality      Special
hi! link typescriptObjectColon            Special
hi! link typescriptObjectLabel            Identifier
hi! link typescriptObjectSpread           Operator
hi! link typescriptOperator               Operator
hi! link typescriptParamImpl              FocusOrangeItalic
hi! link typescriptParens                 Delimiter
hi! link typescriptPredefinedType         Type
hi! link typescriptRestOrSpread           Operator
hi! link typescriptTernaryOp              Operator
hi! link typescriptTypeAnnotation         Special
hi! link typescriptTypeCast               Operator
hi! link typescriptTypeParameter          FocusOrangeItalic
hi! link typescriptTypeReference          Type
hi! link typescriptUnaryOp                Operator
hi! link typescriptVariable               Keyword

hi! link tsxAttrib           FocusGreenItalic
hi! link tsxEqual            Operator
hi! link tsxIntrinsicTagName Keyword
hi! link tsxTagName          Type
" }}}

" Vim: {{{
hi! link vimAutoCmdSfxList     Type
hi! link vimAutoEventList      Type
hi! link vimEnvVar             Constant
hi! link vimFunction           Function
hi! link vimHiBang             Keyword
hi! link vimOption             Type
hi! link vimSetMod             Keyword
hi! link vimSetSep             Delimiter
hi! link vimUserAttrbCmpltFunc Function
hi! link vimUserFunc           Function
" }}}

" XML: {{{
hi! link xmlAttrib  FocusGreenItalic
hi! link xmlEqual   Operator
hi! link xmlTag     Delimiter
hi! link xmlTagName Statement

" Fixes missing highlight over end tags
syn region xmlTagName
	\ matchgroup=xmlTag start=+</[^ /!?<>"']\@=+
	\ matchgroup=xmlTag end=+>+
" }}}

" YAML: {{{
hi! link yamlAlias           FocusGreenItalicUnderline
hi! link yamlAnchor          FocusPinkItalic
hi! link yamlBlockMappingKey FocusCyan
hi! link yamlFlowCollection  FocusPink
hi! link yamlFlowIndicator   Delimiter
hi! link yamlNodeTag         FocusPink
hi! link yamlPlainScalar     FocusYellow
" }}}

" }}}

" Plugins: {{{

" junegunn/fzf {{{
if ! exists('g:fzf_colors')
  let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Search'],
    \ 'fg+':     ['fg', 'Normal'],
    \ 'bg+':     ['bg', 'Normal'],
    \ 'hl+':     ['fg', 'FocusOrange'],
    \ 'info':    ['fg', 'FocusPurple'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'FocusGreen'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'],
    \}
endif
" }}}

" dense-analysis/ale {{{
hi! link ALEError              FocusErrorLine
hi! link ALEWarning            FocusWarnLine
hi! link ALEInfo               FocusInfoLine

hi! link ALEErrorSign          FocusRed
hi! link ALEWarningSign        FocusOrange
hi! link ALEInfoSign           FocusCyan

hi! link ALEVirtualTextError   Comment
hi! link ALEVirtualTextWarning Comment
" }}}

" ctrlpvim/ctrlp.vim: {{{
hi! link CtrlPMatch     IncSearch
hi! link CtrlPBufferHid Normal
" }}}

" airblade/vim-gitgutter {{{
hi! link GitGutterAdd    DiffAdd
hi! link GitGutterChange DiffChange
hi! link GitGutterDelete DiffDelete
" }}}

" Neovim-only plugins {{{
if has('nvim')

  " nvim-treesitter/nvim-treesitter: {{{
  " The nvim-treesitter library defines many global highlight groups that are
  " linked to the regular vim syntax highlight groups. We only need to redefine
  " those highlight groups when the defaults do not match the focus
  " specification.
  " https://github.com/nvim-treesitter/nvim-treesitter/blob/master/plugin/nvim-treesitter.vim

  " deprecated TS* highlight groups
  " see https://github.com/nvim-treesitter/nvim-treesitter/pull/3656
  " # Misc
  hi! link TSPunctSpecial Special
  " # Constants
  hi! link TSConstMacro Macro
  hi! link TSStringEscape Character
  hi! link TSSymbol FocusPurple
  hi! link TSAnnotation FocusYellow
  hi! link TSAttribute FocusGreenItalic
  " # Functions
  hi! link TSFuncBuiltin FocusCyan
  hi! link TSFuncMacro Function
  hi! link TSParameter FocusOrangeItalic
  hi! link TSParameterReference FocusOrange
  hi! link TSField FocusOrange
  hi! link TSConstructor FocusCyan
  " # Keywords
  hi! link TSLabel FocusPurpleItalic
  " # Variable
  hi! link TSVariableBuiltin FocusPurpleItalic
  " # Text
  hi! link TSStrong FocusFgBold
  hi! link TSEmphasis FocusFg
  hi! link TSUnderline Underlined
  hi! link TSTitle FocusYellow
  hi! link TSLiteral FocusYellow
  hi! link TSURI FocusYellow
  " HTML and JSX tag attributes. By default, this group is linked to TSProperty,
  " which in turn links to Identifer (white).
  hi! link TSTagAttribute FocusGreenItalic

  if has('nvim-0.8.1')
    " # Misc
    hi! link @punctuation.delimiter Delimiter
    hi! link @punctuation.bracket FocusFg
    hi! link @punctuation.special Special
    hi! link @punctuation Delimiter
    " # Constants
    hi! link @constant Constant
    hi! link @constant.builtin Constant
    hi! link @constant.macro Macro
    hi! link @string.regex @string.special
    hi! link @string.escape @string.special
    hi! link @string String
    hi! link @string.regexp @string.special
    hi! link @string.special SpecialChar
    hi! link @string.special.symbol FocusPurple
    hi! link @string.special.url Underlined
    hi! link @symbol FocusPurple
    hi! link @annotation FocusYellow
    hi! link @attribute FocusGreenItalic
    hi! link @namespace Structure
    hi! link @module Structure
    hi! link @module.builtin Special
    " # Functions
    hi! link @function.builtin FocusCyan
    hi! link @funcion.macro Function
    hi! link @function Function
    hi! link @parameter FocusOrangeItalic
    hi! link @parameter.reference FocusOrange
    hi! link @field FocusOrange
    hi! link @property FocusFg
    hi! link @constructor FocusCyan
    " # Keywords
    hi! link @label FocusPurpleItalic
    hi! link @keyword.function FocusPink
    hi! link @keyword.operator Operator
    hi! link @keyword Keyword
    hi! link @exception FocusPurple
    hi! link @operator Operator
    " # Types
    hi! link @type Type
    hi! link @type.builtin Special
    hi! link @character Character
    hi! link @character.special SpecialChar
    hi! link @boolean Boolean
    hi! link @number Number
    hi! link @number.float Float
    " # Variable
    hi! link @variable FocusFg
    hi! link @variable.builtin FocusPurpleItalic
    hi! link @variable.parameter FocusOrangeItalic
    hi! link @variable.member  FocusOrange
    " # Text
    hi! link @text FocusFg
    hi! link @text.strong FocusFgBold
    hi! link @text.emphasis FocusFg
    hi! link @text.underline Underlined
    hi! link @text.title FocusYellow
    hi! link @text.literal FocusYellow
    hi! link @text.uri FocusYellow
    hi! link @text.diff.add DiffAdd
    hi! link @text.diff.delete DiffDelete

    hi! link @markup.strong FocusFgBold
    hi! link @markup.italic FocusFgItalic
    hi! link @markup.strikethrough FocusFgStrikethrough
    hi! link @markup.underline Underlined

    hi! link @markup Special
    hi! link @markup.heading FocusYellow
    hi! link @markup.link Underlined
    hi! link @markup.link.uri FocusYellow
    hi! link @markup.link.label SpecialChar
    hi! link @markup.raw FocusYellow
    hi! link @markup.list Special

    hi! link @comment Comment
    hi! link @comment.error DiagnosticError
    hi! link @comment.warning DiagnosticWarn
    hi! link @comment.note DiagnosticInfo
    hi! link @comment.todo Todo

    hi! link @diff.plus Added
    hi! link @diff.minus Removed
    hi! link @diff.delta Changed

    " # Tags
    hi! link @tag FocusCyan
    hi! link @tag.delimiter FocusFg
    " HTML and JSX tag attributes. By default, this group is linked to TSProperty,
    " which in turn links to Identifer (white).
    hi! link @tag.attribute FocusGreenItalic
  endif
  " }}}

  " hrsh7th/nvim-cmp {{{
  hi! link CmpItemAbbrDeprecated FocusError

  hi! link CmpItemAbbrMatch FocusCyan
  hi! link CmpItemAbbrMatchFuzzy FocusCyan

  hi! link CmpItemKindText FocusFg
  hi! link CmpItemKindMethod Function
  hi! link CmpItemKindFunction Function
  hi! link CmpItemKindConstructor FocusCyan
  hi! link CmpItemKindField FocusOrange
  hi! link CmpItemKindVariable FocusPurpleItalic
  hi! link CmpItemKindClass FocusCyan
  hi! link CmpItemKindInterface FocusCyan
  hi! link CmpItemKindModule FocusYellow
  hi! link CmpItemKindProperty FocusPink
  hi! link CmpItemKindUnit FocusFg
  hi! link CmpItemKindValue FocusYellow
  hi! link CmpItemKindEnum FocusPink
  hi! link CmpItemKindKeyword FocusPink
  hi! link CmpItemKindSnippet FocusFg
  hi! link CmpItemKindColor FocusYellow
  hi! link CmpItemKindFile FocusYellow
  hi! link CmpItemKindReference FocusOrange
  hi! link CmpItemKindFolder FocusYellow
  hi! link CmpItemKindEnumMember FocusPurple
  hi! link CmpItemKindConstant FocusPurple
  hi! link CmpItemKindStruct FocusPink
  hi! link CmpItemKindEvent FocusFg
  hi! link CmpItemKindOperator FocusPink
  hi! link CmpItemKindTypeParameter FocusCyan

  hi! link CmpItemMenu Comment
  " }}}

  " lewis6991/gitsigns.nvim {{{
  hi! link GitSignsAdd      DiffAdd
  hi! link GitSignsAddLn    DiffAdd
  hi! link GitSignsAddNr    DiffAdd
  hi! link GitSignsChange   DiffChange
  hi! link GitSignsChangeLn DiffChange
  hi! link GitSignsChangeNr DiffChange

  hi! link GitSignsDelete   FocusRed
  hi! link GitSignsDeleteLn FocusRed
  hi! link GitSignsDeleteNr FocusRed
  " }}}

endif
" }}}

" }}}

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0 et:
