" Morpho Theme: {{{
"
" https://github.com/zenorocha/morpho-theme
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

let g:colors_name = 'morpho'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" Palette: {{{2

let s:fg        = g:morpho#palette.fg

let s:bglighter = g:morpho#palette.bglighter
let s:bglight   = g:morpho#palette.bglight
let s:bg        = g:morpho#palette.bg
let s:bgdark    = g:morpho#palette.bgdark
let s:bgdarker  = g:morpho#palette.bgdarker

let s:comment   = g:morpho#palette.comment
let s:selection = g:morpho#palette.selection
let s:subtle    = g:morpho#palette.subtle

let s:cyan      = g:morpho#palette.cyan
let s:green     = g:morpho#palette.green
let s:orange    = g:morpho#palette.orange
let s:pink      = g:morpho#palette.pink
let s:purple    = g:morpho#palette.purple
let s:red       = g:morpho#palette.red
let s:yellow    = g:morpho#palette.yellow

let s:none      = ['NONE', 'NONE']

if has('nvim')
  for s:i in range(16)
    let g:terminal_color_{s:i} = g:morpho#palette['color_' . s:i]
  endfor
endif

if has('terminal')
  let g:terminal_ansi_colors = []
  for s:i in range(16)
    call add(g:terminal_ansi_colors, g:morpho#palette['color_' . s:i])
  endfor
endif

" }}}2
" User Configuration: {{{2

if !exists('g:morpho_bold')
  let g:morpho_bold = 1
endif

if !exists('g:morpho_italic')
  let g:morpho_italic = 1
endif

if !exists('g:morpho_strikethrough')
  let g:morpho_strikethrough = 1
endif

if !exists('g:morpho_underline')
  let g:morpho_underline = 1
endif

if !exists('g:morpho_undercurl')
  let g:morpho_undercurl = g:morpho_underline
endif

if !exists('g:morpho_full_special_attrs_support')
  let g:morpho_full_special_attrs_support = has('gui_running')
endif

if !exists('g:morpho_inverse')
  let g:morpho_inverse = 1
endif

if !exists('g:morpho_colorterm')
  let g:morpho_colorterm = 1
endif

if !exists('g:morpho_high_contrast_diff')
  let g:morpho_high_contrast_diff = 0
endif

"}}}2
" Script Helpers: {{{2

let s:attrs = {
      \ 'bold': g:morpho_bold == 1 ? 'bold' : 0,
      \ 'italic': g:morpho_italic == 1 ? 'italic' : 0,
      \ 'strikethrough': g:morpho_strikethrough == 1 ? 'strikethrough' : 0,
      \ 'underline': g:morpho_underline == 1 ? 'underline' : 0,
      \ 'undercurl': g:morpho_undercurl == 1 ? 'undercurl' : 0,
      \ 'inverse': g:morpho_inverse == 1 ? 'inverse' : 0,
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
  " the global variable `g:morpho_full_special_attrs_support` explicitly if the
  " default behavior is not desirable.
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !g:morpho_full_special_attrs_support
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
" Morpho Highlight Groups: {{{2

call s:h('MorphoBgLight', s:none, s:bglight)
call s:h('MorphoBgLighter', s:none, s:bglighter)
call s:h('MorphoBgDark', s:none, s:bgdark)
call s:h('MorphoBgDarker', s:none, s:bgdarker)

call s:h('MorphoFg', s:fg)
call s:h('MorphoFgUnderline', s:fg, s:none, [s:attrs.underline])
call s:h('MorphoFgBold', s:fg, s:none, [s:attrs.bold])
call s:h('MorphoFgStrikethrough', s:fg, s:none, [s:attrs.strikethrough])

call s:h('MorphoComment', s:comment)
call s:h('MorphoCommentBold', s:comment, s:none, [s:attrs.bold])

call s:h('MorphoSelection', s:none, s:selection)

call s:h('MorphoSubtle', s:subtle)

call s:h('MorphoCyan', s:cyan)
call s:h('MorphoCyanItalic', s:cyan, s:none, [s:attrs.italic])

call s:h('MorphoGreen', s:green)
call s:h('MorphoGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('MorphoGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('MorphoGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])

call s:h('MorphoOrange', s:orange)
call s:h('MorphoOrangeBold', s:orange, s:none, [s:attrs.bold])
call s:h('MorphoOrangeItalic', s:orange, s:none, [s:attrs.italic])
call s:h('MorphoOrangeBoldItalic', s:orange, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('MorphoOrangeInverse', s:bg, s:orange)

call s:h('MorphoPink', s:pink)
call s:h('MorphoPinkItalic', s:pink, s:none, [s:attrs.italic])

call s:h('MorphoPurple', s:purple)
call s:h('MorphoPurpleBold', s:purple, s:none, [s:attrs.bold])
call s:h('MorphoPurpleItalic', s:purple, s:none, [s:attrs.italic])

call s:h('MorphoRed', s:red)
call s:h('MorphoRedInverse', s:fg, s:red)

call s:h('MorphoYellow', s:yellow)
call s:h('MorphoYellowItalic', s:yellow, s:none, [s:attrs.italic])

call s:h('MorphoError', s:red, s:none, [], s:red)

call s:h('MorphoErrorLine', s:none, s:none, [s:attrs.undercurl], s:red)
call s:h('MorphoWarnLine', s:none, s:none, [s:attrs.undercurl], s:orange)
call s:h('MorphoInfoLine', s:none, s:none, [s:attrs.undercurl], s:cyan)

call s:h('MorphoTodo', s:cyan, s:none, [s:attrs.bold, s:attrs.inverse])
call s:h('MorphoSearch', s:green, s:none, [s:attrs.inverse])
call s:h('MorphoBoundary', s:comment, s:bgdark)
call s:h('MorphoWinSeparator', s:comment, s:bgdark)
call s:h('MorphoLink', s:cyan, s:none, [s:attrs.underline])

if g:morpho_high_contrast_diff
  call s:h('MorphoDiffChange', s:yellow, s:purple)
  call s:h('MorphoDiffDelete', s:bgdark, s:red)
else
  call s:h('MorphoDiffChange', s:orange, s:none)
  call s:h('MorphoDiffDelete', s:red, s:bgdark)
endif

call s:h('MorphoDiffText', s:bg, s:orange)
call s:h('MorphoInlayHint', s:comment, s:bgdark)

" }}}2

" }}}
" User Interface: {{{

set background=dark

" Required as some plugins will overwrite
call s:h('Normal', s:fg, g:morpho_colorterm || has('gui_running') ? s:bg : s:none )
call s:h('StatusLine', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineNC', s:none, s:bglight)
call s:h('StatusLineTerm', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineTermNC', s:none, s:bglight)
call s:h('WildMenu', s:bg, s:purple, [s:attrs.bold])
call s:h('CursorLine', s:none, s:subtle)

hi! link ColorColumn  MorphoBgDark
hi! link CursorColumn CursorLine
hi! link CursorLineNr MorphoYellow
hi! link DiffAdd      MorphoGreen
hi! link DiffAdded    DiffAdd
hi! link DiffChange   MorphoDiffChange
hi! link DiffDelete   MorphoDiffDelete
hi! link DiffRemoved  DiffDelete
hi! link DiffText     MorphoDiffText
hi! link Directory    MorphoPurpleBold
hi! link ErrorMsg     MorphoRedInverse
hi! link FoldColumn   MorphoSubtle
hi! link Folded       MorphoBoundary
hi! link IncSearch    MorphoOrangeInverse
call s:h('LineNr', s:comment)
hi! link MoreMsg      MorphoFgBold
hi! link NonText      MorphoSubtle
hi! link Pmenu        MorphoBgDark
hi! link PmenuSbar    MorphoBgDark
hi! link PmenuSel     MorphoSelection
hi! link PmenuThumb   MorphoSelection
call s:h('PmenuMatch', s:cyan, s:bgdark)
call s:h('PmenuMatchSel', s:cyan, s:selection)
hi! link Question     MorphoFgBold
hi! link Search       MorphoSearch
call s:h('SignColumn', s:comment)
hi! link TabLine      MorphoBoundary
hi! link TabLineFill  MorphoBgDark
hi! link TabLineSel   Normal
hi! link Title        MorphoGreenBold
hi! link VertSplit    MorphoWinSeparator
hi! link Visual       MorphoSelection
hi! link VisualNOS    Visual
hi! link WarningMsg   MorphoOrangeInverse

" }}}
" Syntax: {{{

" Required as some plugins will overwrite
call s:h('MatchParen', s:green, s:none, [s:attrs.underline])
call s:h('Conceal', s:cyan, s:none)

" Neovim uses SpecialKey for escape characters only. Vim uses it for that, plus whitespace.
if has('nvim')
  hi! link SpecialKey MorphoRed
  hi! link LspReferenceText MorphoSelection
  hi! link LspReferenceRead MorphoSelection
  hi! link LspReferenceWrite MorphoSelection
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
  hi! link LspInlayHint MorphoInlayHint

  hi! link DiagnosticInfo MorphoCyan
  hi! link DiagnosticHint MorphoCyan
  hi! link DiagnosticError MorphoError
  hi! link DiagnosticWarn MorphoOrange
  hi! link DiagnosticUnderlineError MorphoErrorLine
  hi! link DiagnosticUnderlineHint MorphoInfoLine
  hi! link DiagnosticUnderlineInfo MorphoInfoLine
  hi! link DiagnosticUnderlineWarn MorphoWarnLine

  hi! link WinSeparator MorphoWinSeparator
  hi! link NormalFloat Pmenu

  if has('nvim-0.9')
    hi! link  @lsp.type.class MorphoCyan
    hi! link  @lsp.type.decorator MorphoGreen
    hi! link  @lsp.type.enum MorphoCyan
    hi! link  @lsp.type.enumMember MorphoPurple
    hi! link  @lsp.type.function MorphoGreen
    hi! link  @lsp.type.interface MorphoCyan
    hi! link  @lsp.type.macro MorphoCyan
    hi! link  @lsp.type.method MorphoGreen
    hi! link  @lsp.type.namespace MorphoCyan
    hi! link  @lsp.type.parameter MorphoOrangeItalic
    hi! link  @lsp.type.property MorphoOrange
    hi! link  @lsp.type.struct MorphoCyan
    hi! link  @lsp.type.type MorphoCyanItalic
    hi! link  @lsp.type.typeParameter MorphoPink
    hi! link  @lsp.type.variable MorphoFg
  endif
else
  hi! link SpecialKey MorphoPink
endif

hi! link Comment MorphoComment
hi! link Underlined MorphoFgUnderline
hi! link Todo MorphoTodo

hi! link Error MorphoError
hi! link SpellBad MorphoErrorLine
hi! link SpellLocal MorphoWarnLine
hi! link SpellCap MorphoInfoLine
hi! link SpellRare MorphoInfoLine

hi! link Constant MorphoPurple
hi! link String MorphoYellow
hi! link Character MorphoPink
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Constant

hi! link Identifier MorphoFg
hi! link Function MorphoGreen

hi! link Statement MorphoPink
hi! link Conditional MorphoPink
hi! link Repeat MorphoPink
hi! link Label MorphoPink
hi! link Operator MorphoPink
hi! link Keyword MorphoPink
hi! link Exception MorphoPink

hi! link PreProc MorphoPink
hi! link Include MorphoPink
hi! link Define MorphoPink
hi! link Macro MorphoPink
hi! link PreCondit MorphoPink
hi! link StorageClass MorphoPink
hi! link Structure MorphoPink
hi! link Typedef MorphoPink

hi! link Type MorphoCyanItalic

hi! link Delimiter MorphoFg

hi! link Special MorphoPink
hi! link SpecialComment MorphoCyanItalic
hi! link Tag MorphoCyan
hi! link helpHyperTextJump MorphoLink
hi! link helpCommand MorphoPurple
hi! link helpExample MorphoGreen
hi! link helpBacktick Special

" }}}

" Languages: {{{

" CSS: {{{
hi! link cssAttrComma         Delimiter
hi! link cssAttrRegion        MorphoPink
hi! link cssAttributeSelector MorphoGreenItalic
hi! link cssBraces            Delimiter
hi! link cssFunctionComma     Delimiter
hi! link cssNoise             MorphoPink
hi! link cssProp              MorphoCyan
hi! link cssPseudoClass       MorphoPink
hi! link cssPseudoClassId     MorphoGreenItalic
hi! link cssUnitDecorators    MorphoPink
hi! link cssVendor            MorphoGreenItalic
" }}}

" Git Commit: {{{
" The following two are misnomers. Colors are correct.
hi! link diffFile    MorphoGreen
hi! link diffNewFile MorphoRed

hi! link diffAdded   MorphoGreen
hi! link diffLine    MorphoCyanItalic
hi! link diffRemoved MorphoRed
" }}}

" HTML: {{{
hi! link htmlTag         MorphoFg
hi! link htmlArg         MorphoGreenItalic
hi! link htmlTitle       MorphoFg
hi! link htmlH1          MorphoFg
hi! link htmlSpecialChar MorphoPurple
" }}}

" JavaScript: {{{
hi! link javaScriptBraces   Delimiter
hi! link javaScriptNumber   Constant
hi! link javaScriptNull     Constant
hi! link javaScriptFunction Keyword

" pangloss/vim-javascript
hi! link jsArrowFunction           Operator
hi! link jsBuiltins                MorphoCyan
hi! link jsClassDefinition         MorphoCyan
hi! link jsClassMethodType         Keyword
hi! link jsDestructuringAssignment MorphoOrangeItalic
hi! link jsDocParam                MorphoOrangeItalic
hi! link jsDocTags                 Keyword
hi! link jsDocType                 Type
hi! link jsDocTypeBrackets         MorphoCyan
hi! link jsFuncArgOperator         Operator
hi! link jsFuncArgs                MorphoOrangeItalic
hi! link jsFunction                Keyword
hi! link jsNull                    Constant
hi! link jsObjectColon             MorphoPink
hi! link jsSuper                   MorphoPurpleItalic
hi! link jsTemplateBraces          Special
hi! link jsThis                    MorphoPurpleItalic
hi! link jsUndefined               Constant

" maxmellon/vim-jsx-pretty
hi! link jsxTag             Keyword
hi! link jsxTagName         Keyword
hi! link jsxComponentName   Type
hi! link jsxCloseTag        Type
hi! link jsxAttrib          MorphoGreenItalic
hi! link jsxCloseString     Identifier
hi! link jsxOpenPunct       Identifier
" }}}

" JSON: {{{
hi! link jsonKeyword      MorphoCyan
hi! link jsonKeywordMatch MorphoPink
" }}}

" Lua: {{{
hi! link luaFunc  MorphoCyan
hi! link luaTable MorphoFg

" tbastos/vim-lua
hi! link luaBraces       MorphoFg
hi! link luaBuiltIn      Constant
hi! link luaDocTag       Keyword
hi! link luaErrHand      MorphoCyan
hi! link luaFuncArgName  MorphoOrangeItalic
hi! link luaFuncCall     Function
hi! link luaLocal        Keyword
hi! link luaSpecialTable Constant
hi! link luaSpecialValue MorphoCyan
" }}}

" Markdown: {{{
hi! link markdownBlockquote        MorphoCyan
hi! link markdownBold              MorphoOrangeBold
hi! link markdownBoldItalic        MorphoOrangeBoldItalic
hi! link markdownCodeBlock         MorphoGreen
hi! link markdownCode              MorphoGreen
hi! link markdownCodeDelimiter     MorphoGreen
hi! link markdownH1                MorphoPurpleBold
hi! link markdownH2                markdownH1
hi! link markdownH3                markdownH1
hi! link markdownH4                markdownH1
hi! link markdownH5                markdownH1
hi! link markdownH6                markdownH1
hi! link markdownHeadingDelimiter  markdownH1
hi! link markdownHeadingRule       markdownH1
hi! link markdownItalic            MorphoYellowItalic
hi! link markdownLinkText          MorphoPink
hi! link markdownListMarker        MorphoCyan
hi! link markdownOrderedListMarker MorphoCyan
hi! link markdownRule              MorphoComment
hi! link markdownUrl               MorphoLink

" plasticboy/vim-markdown
hi! link htmlBold       MorphoOrangeBold
hi! link htmlBoldItalic MorphoOrangeBoldItalic
hi! link htmlH1         MorphoPurpleBold
hi! link htmlItalic     MorphoYellowItalic
hi! link mkdBlockquote  MorphoYellowItalic
hi! link mkdBold        MorphoOrangeBold
hi! link mkdBoldItalic  MorphoOrangeBoldItalic
hi! link mkdCode        MorphoGreen
hi! link mkdCodeEnd     MorphoGreen
hi! link mkdCodeStart   MorphoGreen
hi! link mkdHeading     MorphoPurpleBold
hi! link mkdInlineUrl   MorphoLink
hi! link mkdItalic      MorphoYellowItalic
hi! link mkdLink        MorphoPink
hi! link mkdListItem    MorphoCyan
hi! link mkdRule        MorphoComment
hi! link mkdUrl         MorphoLink
" }}}

" OCaml: {{{
hi! link ocamlModule  Type
hi! link ocamlModPath Normal
hi! link ocamlLabel   MorphoOrangeItalic
" }}}

" Perl: {{{
" Regex
hi! link perlMatchStartEnd       MorphoRed

" Builtin functions
hi! link perlOperator            MorphoCyan
hi! link perlStatementFiledesc   MorphoCyan
hi! link perlStatementFiles      MorphoCyan
hi! link perlStatementFlow       MorphoCyan
hi! link perlStatementHash       MorphoCyan
hi! link perlStatementIOfunc     MorphoCyan
hi! link perlStatementIPC        MorphoCyan
hi! link perlStatementList       MorphoCyan
hi! link perlStatementMisc       MorphoCyan
hi! link perlStatementNetwork    MorphoCyan
hi! link perlStatementNumeric    MorphoCyan
hi! link perlStatementProc       MorphoCyan
hi! link perlStatementPword      MorphoCyan
hi! link perlStatementRegexp     MorphoCyan
hi! link perlStatementScalar     MorphoCyan
hi! link perlStatementSocket     MorphoCyan
hi! link perlStatementTime       MorphoCyan
hi! link perlStatementVector     MorphoCyan

" Highlighting for quoting constructs, tied to existing option in vim-perl
if get(g:, 'perl_string_as_statement', 0)
  hi! link perlStringStartEnd MorphoRed
endif

" Signatures
hi! link perlSignature           MorphoOrangeItalic
hi! link perlSubPrototype        MorphoOrangeItalic

" Hash keys
hi! link perlVarSimpleMemberName MorphoPurple
" }}}

" PHP: {{{
hi! link phpClass           Type
hi! link phpClasses         Type
hi! link phpDocTags         MorphoCyanItalic
hi! link phpFunction        Function
hi! link phpParent          Normal
hi! link phpSpecialFunction MorphoCyan
" }}}

" PlantUML: {{{
hi! link plantumlClassPrivate              SpecialKey
hi! link plantumlClassProtected            MorphoOrange
hi! link plantumlClassPublic               Function
hi! link plantumlColonLine                 String
hi! link plantumlDirectedOrVerticalArrowLR Constant
hi! link plantumlDirectedOrVerticalArrowRL Constant
hi! link plantumlHorizontalArrow           Constant
hi! link plantumlSkinParamKeyword          MorphoCyan
hi! link plantumlTypeKeyword               Keyword
" }}}

" PureScript: {{{
hi! link purescriptModule Type
hi! link purescriptImport MorphoCyan
hi! link purescriptImportAs MorphoCyan
hi! link purescriptOperator Operator
hi! link purescriptBacktick Operator
" }}}

" Python: {{{
hi! link pythonBuiltinObj    Type
hi! link pythonBuiltinObject Type
hi! link pythonBuiltinType   Type
hi! link pythonClassVar      MorphoPurpleItalic
hi! link pythonExClass       Type
hi! link pythonNone          Type
hi! link pythonRun           Comment
" }}}

" reStructuredText: {{{
hi! link rstComment                             Comment
hi! link rstTransition                          Comment
hi! link rstCodeBlock                           MorphoGreen
hi! link rstInlineLiteral                       MorphoGreen
hi! link rstLiteralBlock                        MorphoGreen
hi! link rstQuotedLiteralBlock                  MorphoGreen
hi! link rstStandaloneHyperlink                 MorphoLink
hi! link rstStrongEmphasis                      MorphoOrangeBold
hi! link rstSections                            MorphoPurpleBold
hi! link rstEmphasis                            MorphoYellowItalic
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

hi! link rubyBlockArgument          MorphoOrangeItalic
hi! link rubyBlockParameter         MorphoOrangeItalic
hi! link rubyCurlyBlock             MorphoPink
hi! link rubyGlobalVariable         MorphoPurple
hi! link rubyInstanceVariable       MorphoPurpleItalic
hi! link rubyInterpolationDelimiter MorphoPink
hi! link rubyRegexpDelimiter        MorphoRed
hi! link rubyStringDelimiter        MorphoYellow
" }}}

" Rust: {{{
hi! link rustCommentLineDoc Comment
" }}}

" Sass: {{{
hi! link sassClass                  cssClassName
hi! link sassClassChar              cssClassNameDot
hi! link sassId                     cssIdentifier
hi! link sassIdChar                 cssIdentifier
hi! link sassInterpolationDelimiter MorphoPink
hi! link sassMixinName              Function
hi! link sassProperty               cssProp
hi! link sassVariableAssignment     Operator
" }}}

" Shell: {{{
hi! link shCommandSub NONE
hi! link shEscape     MorphoRed
hi! link shParen      NONE
hi! link shParenError NONE
" }}}

" Tex: {{{
hi! link texBeginEndName  MorphoOrangeItalic
hi! link texBoldItalStyle MorphoOrangeBoldItalic
hi! link texBoldStyle     MorphoOrangeBold
hi! link texInputFile     MorphoOrangeItalic
hi! link texItalStyle     MorphoYellowItalic
hi! link texLigature      MorphoPurple
hi! link texMath          MorphoPurple
hi! link texMathMatcher   MorphoPurple
hi! link texMathSymbol    MorphoPurple
hi! link texSpecialChar   MorphoPurple
hi! link texSubscripts    MorphoPurple
hi! link texTitle         MorphoFgBold
" }}}

" Typescript: {{{
hi! link typescriptAliasDeclaration       Type
hi! link typescriptArrayMethod            Function
hi! link typescriptArrowFunc              Operator
hi! link typescriptArrowFuncArg           MorphoOrangeItalic
hi! link typescriptAssign                 Operator
hi! link typescriptBOMWindowProp          Constant
hi! link typescriptBinaryOp               Operator
hi! link typescriptBraces                 Delimiter
hi! link typescriptCall                   typescriptArrowFuncArg
hi! link typescriptClassHeritage          Type
hi! link typescriptClassName              Type
hi! link typescriptDateMethod             MorphoCyan
hi! link typescriptDateStaticMethod       Function
hi! link typescriptDecorator              MorphoGreenItalic
hi! link typescriptDefaultParam           Operator
hi! link typescriptES6SetMethod           MorphoCyan
hi! link typescriptEndColons              Delimiter
hi! link typescriptEnum                   Type
hi! link typescriptEnumKeyword            Keyword
hi! link typescriptFuncComma              Delimiter
hi! link typescriptFuncKeyword            Keyword
hi! link typescriptFuncType               MorphoOrangeItalic
hi! link typescriptFuncTypeArrow          Operator
hi! link typescriptGlobal                 Type
hi! link typescriptGlobalMethod           MorphoCyan
hi! link typescriptGlobalObjects          Type
hi! link typescriptIdentifier             MorphoPurpleItalic
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
hi! link typescriptParamImpl              MorphoOrangeItalic
hi! link typescriptParens                 Delimiter
hi! link typescriptPredefinedType         Type
hi! link typescriptRestOrSpread           Operator
hi! link typescriptTernaryOp              Operator
hi! link typescriptTypeAnnotation         Special
hi! link typescriptTypeCast               Operator
hi! link typescriptTypeParameter          MorphoOrangeItalic
hi! link typescriptTypeReference          Type
hi! link typescriptUnaryOp                Operator
hi! link typescriptVariable               Keyword

hi! link tsxAttrib           MorphoGreenItalic
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
hi! link xmlAttrib  MorphoGreenItalic
hi! link xmlEqual   Operator
hi! link xmlTag     Delimiter
hi! link xmlTagName Statement

" Fixes missing highlight over end tags
syn region xmlTagName
	\ matchgroup=xmlTag start=+</[^ /!?<>"']\@=+
	\ matchgroup=xmlTag end=+>+
" }}}

" YAML: {{{
hi! link yamlAlias           MorphoGreenItalicUnderline
hi! link yamlAnchor          MorphoPinkItalic
hi! link yamlBlockMappingKey MorphoCyan
hi! link yamlFlowCollection  MorphoPink
hi! link yamlFlowIndicator   Delimiter
hi! link yamlNodeTag         MorphoPink
hi! link yamlPlainScalar     MorphoYellow
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
    \ 'hl+':     ['fg', 'MorphoOrange'],
    \ 'info':    ['fg', 'MorphoPurple'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'MorphoGreen'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'],
    \}
endif
" }}}

" dense-analysis/ale {{{
hi! link ALEError              MorphoErrorLine
hi! link ALEWarning            MorphoWarnLine
hi! link ALEInfo               MorphoInfoLine

hi! link ALEErrorSign          MorphoRed
hi! link ALEWarningSign        MorphoOrange
hi! link ALEInfoSign           MorphoCyan

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
  " those highlight groups when the defaults do not match the morpho
  " specification.
  " https://github.com/nvim-treesitter/nvim-treesitter/blob/master/plugin/nvim-treesitter.vim

  " deprecated TS* highlight groups
  " see https://github.com/nvim-treesitter/nvim-treesitter/pull/3656
  " # Misc
  hi! link TSPunctSpecial Special
  " # Constants
  hi! link TSConstMacro Macro
  hi! link TSStringEscape Character
  hi! link TSSymbol MorphoPurple
  hi! link TSAnnotation MorphoYellow
  hi! link TSAttribute MorphoGreenItalic
  " # Functions
  hi! link TSFuncBuiltin MorphoCyan
  hi! link TSFuncMacro Function
  hi! link TSParameter MorphoOrangeItalic
  hi! link TSParameterReference MorphoOrange
  hi! link TSField MorphoOrange
  hi! link TSConstructor MorphoCyan
  " # Keywords
  hi! link TSLabel MorphoPurpleItalic
  " # Variable
  hi! link TSVariableBuiltin MorphoPurpleItalic
  " # Text
  hi! link TSStrong MorphoFgBold
  hi! link TSEmphasis MorphoFg
  hi! link TSUnderline Underlined
  hi! link TSTitle MorphoYellow
  hi! link TSLiteral MorphoYellow
  hi! link TSURI MorphoYellow
  " HTML and JSX tag attributes. By default, this group is linked to TSProperty,
  " which in turn links to Identifer (white).
  hi! link TSTagAttribute MorphoGreenItalic

  if has('nvim-0.8.1')
    " # Misc
    hi! link @punctuation.delimiter Delimiter
    hi! link @punctuation.bracket MorphoFg
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
    hi! link @string.special.symbol MorphoPurple
    hi! link @string.special.url Underlined
    hi! link @symbol MorphoPurple
    hi! link @annotation MorphoYellow
    hi! link @attribute MorphoGreenItalic
    hi! link @namespace Structure
    hi! link @module Structure
    hi! link @module.builtin Special
    " # Functions
    hi! link @function.builtin MorphoCyan
    hi! link @funcion.macro Function
    hi! link @function Function
    hi! link @parameter MorphoOrangeItalic
    hi! link @parameter.reference MorphoOrange
    hi! link @field MorphoOrange
    hi! link @property MorphoFg
    hi! link @constructor MorphoCyan
    " # Keywords
    hi! link @label MorphoPurpleItalic
    hi! link @keyword.function MorphoPink
    hi! link @keyword.operator Operator
    hi! link @keyword Keyword
    hi! link @exception MorphoPurple
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
    hi! link @variable MorphoFg
    hi! link @variable.builtin MorphoPurpleItalic
    hi! link @variable.parameter MorphoOrangeItalic
    hi! link @variable.member  MorphoOrange
    " # Text
    hi! link @text MorphoFg
    hi! link @text.strong MorphoFgBold
    hi! link @text.emphasis MorphoFg
    hi! link @text.underline Underlined
    hi! link @text.title MorphoYellow
    hi! link @text.literal MorphoYellow
    hi! link @text.uri MorphoYellow
    hi! link @text.diff.add DiffAdd
    hi! link @text.diff.delete DiffDelete

    hi! link @markup.strong MorphoFgBold
    hi! link @markup.italic MorphoFgItalic
    hi! link @markup.strikethrough MorphoFgStrikethrough
    hi! link @markup.underline Underlined

    hi! link @markup Special
    hi! link @markup.heading MorphoYellow
    hi! link @markup.link Underlined
    hi! link @markup.link.uri MorphoYellow
    hi! link @markup.link.label SpecialChar
    hi! link @markup.raw MorphoYellow
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
    hi! link @tag MorphoCyan
    hi! link @tag.delimiter MorphoFg
    " HTML and JSX tag attributes. By default, this group is linked to TSProperty,
    " which in turn links to Identifer (white).
    hi! link @tag.attribute MorphoGreenItalic
  endif
  " }}}

  " hrsh7th/nvim-cmp {{{
  hi! link CmpItemAbbrDeprecated MorphoError

  hi! link CmpItemAbbrMatch MorphoCyan
  hi! link CmpItemAbbrMatchFuzzy MorphoCyan

  hi! link CmpItemKindText MorphoFg
  hi! link CmpItemKindMethod Function
  hi! link CmpItemKindFunction Function
  hi! link CmpItemKindConstructor MorphoCyan
  hi! link CmpItemKindField MorphoOrange
  hi! link CmpItemKindVariable MorphoPurpleItalic
  hi! link CmpItemKindClass MorphoCyan
  hi! link CmpItemKindInterface MorphoCyan
  hi! link CmpItemKindModule MorphoYellow
  hi! link CmpItemKindProperty MorphoPink
  hi! link CmpItemKindUnit MorphoFg
  hi! link CmpItemKindValue MorphoYellow
  hi! link CmpItemKindEnum MorphoPink
  hi! link CmpItemKindKeyword MorphoPink
  hi! link CmpItemKindSnippet MorphoFg
  hi! link CmpItemKindColor MorphoYellow
  hi! link CmpItemKindFile MorphoYellow
  hi! link CmpItemKindReference MorphoOrange
  hi! link CmpItemKindFolder MorphoYellow
  hi! link CmpItemKindEnumMember MorphoPurple
  hi! link CmpItemKindConstant MorphoPurple
  hi! link CmpItemKindStruct MorphoPink
  hi! link CmpItemKindEvent MorphoFg
  hi! link CmpItemKindOperator MorphoPink
  hi! link CmpItemKindTypeParameter MorphoCyan

  hi! link CmpItemMenu Comment
  " }}}

  " lewis6991/gitsigns.nvim {{{
  hi! link GitSignsAdd      DiffAdd
  hi! link GitSignsAddLn    DiffAdd
  hi! link GitSignsAddNr    DiffAdd
  hi! link GitSignsChange   DiffChange
  hi! link GitSignsChangeLn DiffChange
  hi! link GitSignsChangeNr DiffChange

  hi! link GitSignsDelete   MorphoRed
  hi! link GitSignsDeleteLn MorphoRed
  hi! link GitSignsDeleteNr MorphoRed
  " }}}

endif
" }}}

" }}}

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0 et:
