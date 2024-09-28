" Lines Theme: {{{
"
" https://github.com/zenorocha/lines-theme
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

let g:colors_name = 'lines'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" Palette: {{{2

let s:fg        = g:lines#palette.fg

let s:bglighter = g:lines#palette.bglighter
let s:bglight   = g:lines#palette.bglight
let s:bg        = g:lines#palette.bg
let s:bgdark    = g:lines#palette.bgdark
let s:bgdarker  = g:lines#palette.bgdarker

let s:comment   = g:lines#palette.comment
let s:selection = g:lines#palette.selection
let s:subtle    = g:lines#palette.subtle

let s:cyan      = g:lines#palette.cyan
let s:green     = g:lines#palette.green
let s:orange    = g:lines#palette.orange
let s:pink      = g:lines#palette.pink
let s:purple    = g:lines#palette.purple
let s:red       = g:lines#palette.red
let s:yellow    = g:lines#palette.yellow

let s:none      = ['NONE', 'NONE']

if has('nvim')
  for s:i in range(16)
    let g:terminal_color_{s:i} = g:lines#palette['color_' . s:i]
  endfor
endif

if has('terminal')
  let g:terminal_ansi_colors = []
  for s:i in range(16)
    call add(g:terminal_ansi_colors, g:lines#palette['color_' . s:i])
  endfor
endif

" }}}2
" User Configuration: {{{2

if !exists('g:lines_bold')
  let g:lines_bold = 1
endif

if !exists('g:lines_italic')
  let g:lines_italic = 1
endif

if !exists('g:lines_strikethrough')
  let g:lines_strikethrough = 1
endif

if !exists('g:lines_underline')
  let g:lines_underline = 1
endif

if !exists('g:lines_undercurl')
  let g:lines_undercurl = g:lines_underline
endif

if !exists('g:lines_full_special_attrs_support')
  let g:lines_full_special_attrs_support = has('gui_running')
endif

if !exists('g:lines_inverse')
  let g:lines_inverse = 1
endif

if !exists('g:lines_colorterm')
  let g:lines_colorterm = 1
endif

if !exists('g:lines_high_contrast_diff')
  let g:lines_high_contrast_diff = 0
endif

"}}}2
" Script Helpers: {{{2

let s:attrs = {
      \ 'bold': g:lines_bold == 1 ? 'bold' : 0,
      \ 'italic': g:lines_italic == 1 ? 'italic' : 0,
      \ 'strikethrough': g:lines_strikethrough == 1 ? 'strikethrough' : 0,
      \ 'underline': g:lines_underline == 1 ? 'underline' : 0,
      \ 'undercurl': g:lines_undercurl == 1 ? 'undercurl' : 0,
      \ 'inverse': g:lines_inverse == 1 ? 'inverse' : 0,
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
  " the global variable `g:lines_full_special_attrs_support` explicitly if the
  " default behavior is not desirable.
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !g:lines_full_special_attrs_support
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
" Lines Highlight Groups: {{{2

call s:h('LinesBgLight', s:none, s:bglight)
call s:h('LinesBgLighter', s:none, s:bglighter)
call s:h('LinesBgDark', s:none, s:bgdark)
call s:h('LinesBgDarker', s:none, s:bgdarker)

call s:h('LinesFg', s:fg)
call s:h('LinesFgUnderline', s:fg, s:none, [s:attrs.underline])
call s:h('LinesFgBold', s:fg, s:none, [s:attrs.bold])
call s:h('LinesFgStrikethrough', s:fg, s:none, [s:attrs.strikethrough])

call s:h('LinesComment', s:comment)
call s:h('LinesCommentBold', s:comment, s:none, [s:attrs.bold])

call s:h('LinesSelection', s:none, s:selection)

call s:h('LinesSubtle', s:subtle)

call s:h('LinesCyan', s:cyan)
call s:h('LinesCyanItalic', s:cyan, s:none, [s:attrs.italic])

call s:h('LinesGreen', s:green)
call s:h('LinesGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('LinesGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('LinesGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])

call s:h('LinesOrange', s:orange)
call s:h('LinesOrangeBold', s:orange, s:none, [s:attrs.bold])
call s:h('LinesOrangeItalic', s:orange, s:none, [s:attrs.italic])
call s:h('LinesOrangeBoldItalic', s:orange, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('LinesOrangeInverse', s:bg, s:orange)

call s:h('LinesPink', s:pink)
call s:h('LinesPinkItalic', s:pink, s:none, [s:attrs.italic])

call s:h('LinesPurple', s:purple)
call s:h('LinesPurpleBold', s:purple, s:none, [s:attrs.bold])
call s:h('LinesPurpleItalic', s:purple, s:none, [s:attrs.italic])

call s:h('LinesRed', s:red)
call s:h('LinesRedInverse', s:fg, s:red)

call s:h('LinesYellow', s:yellow)
call s:h('LinesYellowItalic', s:yellow, s:none, [s:attrs.italic])

call s:h('LinesError', s:red, s:none, [], s:red)

call s:h('LinesErrorLine', s:none, s:none, [s:attrs.undercurl], s:red)
call s:h('LinesWarnLine', s:none, s:none, [s:attrs.undercurl], s:orange)
call s:h('LinesInfoLine', s:none, s:none, [s:attrs.undercurl], s:cyan)

call s:h('LinesTodo', s:cyan, s:none, [s:attrs.bold, s:attrs.inverse])
call s:h('LinesSearch', s:green, s:none, [s:attrs.inverse])
call s:h('LinesBoundary', s:comment, s:bgdark)
call s:h('LinesWinSeparator', s:comment, s:bgdark)
call s:h('LinesLink', s:cyan, s:none, [s:attrs.underline])

if g:lines_high_contrast_diff
  call s:h('LinesDiffChange', s:yellow, s:purple)
  call s:h('LinesDiffDelete', s:bgdark, s:red)
else
  call s:h('LinesDiffChange', s:orange, s:none)
  call s:h('LinesDiffDelete', s:red, s:bgdark)
endif

call s:h('LinesDiffText', s:bg, s:orange)
call s:h('LinesInlayHint', s:comment, s:bgdark)

" }}}2

" }}}
" User Interface: {{{

set background=dark

" Required as some plugins will overwrite
call s:h('Normal', s:fg, g:lines_colorterm || has('gui_running') ? s:bg : s:none )
call s:h('StatusLine', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineNC', s:none, s:bglight)
call s:h('StatusLineTerm', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineTermNC', s:none, s:bglight)
call s:h('WildMenu', s:bg, s:purple, [s:attrs.bold])
call s:h('CursorLine', s:none, s:subtle)

hi! link ColorColumn  LinesBgDark
hi! link CursorColumn CursorLine
hi! link CursorLineNr LinesYellow
hi! link DiffAdd      LinesGreen
hi! link DiffAdded    DiffAdd
hi! link DiffChange   LinesDiffChange
hi! link DiffDelete   LinesDiffDelete
hi! link DiffRemoved  DiffDelete
hi! link DiffText     LinesDiffText
hi! link Directory    LinesPurpleBold
hi! link ErrorMsg     LinesRedInverse
hi! link FoldColumn   LinesSubtle
hi! link Folded       LinesBoundary
hi! link IncSearch    LinesOrangeInverse
call s:h('LineNr', s:comment)
hi! link MoreMsg      LinesFgBold
hi! link NonText      LinesSubtle
hi! link Pmenu        LinesBgDark
hi! link PmenuSbar    LinesBgDark
hi! link PmenuSel     LinesSelection
hi! link PmenuThumb   LinesSelection
call s:h('PmenuMatch', s:cyan, s:bgdark)
call s:h('PmenuMatchSel', s:cyan, s:selection)
hi! link Question     LinesFgBold
hi! link Search       LinesSearch
call s:h('SignColumn', s:comment)
hi! link TabLine      LinesBoundary
hi! link TabLineFill  LinesBgDark
hi! link TabLineSel   Normal
hi! link Title        LinesGreenBold
hi! link VertSplit    LinesWinSeparator
hi! link Visual       LinesSelection
hi! link VisualNOS    Visual
hi! link WarningMsg   LinesOrangeInverse

" }}}
" Syntax: {{{

" Required as some plugins will overwrite
call s:h('MatchParen', s:green, s:none, [s:attrs.underline])
call s:h('Conceal', s:cyan, s:none)

" Neovim uses SpecialKey for escape characters only. Vim uses it for that, plus whitespace.
if has('nvim')
  hi! link SpecialKey LinesRed
  hi! link LspReferenceText LinesSelection
  hi! link LspReferenceRead LinesSelection
  hi! link LspReferenceWrite LinesSelection
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
  hi! link LspInlayHint LinesInlayHint

  hi! link DiagnosticInfo LinesCyan
  hi! link DiagnosticHint LinesCyan
  hi! link DiagnosticError LinesError
  hi! link DiagnosticWarn LinesOrange
  hi! link DiagnosticUnderlineError LinesErrorLine
  hi! link DiagnosticUnderlineHint LinesInfoLine
  hi! link DiagnosticUnderlineInfo LinesInfoLine
  hi! link DiagnosticUnderlineWarn LinesWarnLine

  hi! link WinSeparator LinesWinSeparator
  hi! link NormalFloat Pmenu

  if has('nvim-0.9')
    hi! link  @lsp.type.class LinesCyan
    hi! link  @lsp.type.decorator LinesGreen
    hi! link  @lsp.type.enum LinesCyan
    hi! link  @lsp.type.enumMember LinesPurple
    hi! link  @lsp.type.function LinesGreen
    hi! link  @lsp.type.interface LinesCyan
    hi! link  @lsp.type.macro LinesCyan
    hi! link  @lsp.type.method LinesGreen
    hi! link  @lsp.type.namespace LinesCyan
    hi! link  @lsp.type.parameter LinesOrangeItalic
    hi! link  @lsp.type.property LinesOrange
    hi! link  @lsp.type.struct LinesCyan
    hi! link  @lsp.type.type LinesCyanItalic
    hi! link  @lsp.type.typeParameter LinesPink
    hi! link  @lsp.type.variable LinesFg
  endif
else
  hi! link SpecialKey LinesPink
endif

hi! link Comment LinesComment
hi! link Underlined LinesFgUnderline
hi! link Todo LinesTodo

hi! link Error LinesError
hi! link SpellBad LinesErrorLine
hi! link SpellLocal LinesWarnLine
hi! link SpellCap LinesInfoLine
hi! link SpellRare LinesInfoLine

hi! link Constant LinesPurple
hi! link String LinesYellow
hi! link Character LinesPink
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Constant

hi! link Identifier LinesFg
hi! link Function LinesGreen

hi! link Statement LinesPink
hi! link Conditional LinesPink
hi! link Repeat LinesPink
hi! link Label LinesPink
hi! link Operator LinesPink
hi! link Keyword LinesPink
hi! link Exception LinesPink

hi! link PreProc LinesPink
hi! link Include LinesPink
hi! link Define LinesPink
hi! link Macro LinesPink
hi! link PreCondit LinesPink
hi! link StorageClass LinesPink
hi! link Structure LinesPink
hi! link Typedef LinesPink

hi! link Type LinesCyanItalic

hi! link Delimiter LinesFg

hi! link Special LinesPink
hi! link SpecialComment LinesCyanItalic
hi! link Tag LinesCyan
hi! link helpHyperTextJump LinesLink
hi! link helpCommand LinesPurple
hi! link helpExample LinesGreen
hi! link helpBacktick Special

" }}}

" Languages: {{{

" CSS: {{{
hi! link cssAttrComma         Delimiter
hi! link cssAttrRegion        LinesPink
hi! link cssAttributeSelector LinesGreenItalic
hi! link cssBraces            Delimiter
hi! link cssFunctionComma     Delimiter
hi! link cssNoise             LinesPink
hi! link cssProp              LinesCyan
hi! link cssPseudoClass       LinesPink
hi! link cssPseudoClassId     LinesGreenItalic
hi! link cssUnitDecorators    LinesPink
hi! link cssVendor            LinesGreenItalic
" }}}

" Git Commit: {{{
" The following two are misnomers. Colors are correct.
hi! link diffFile    LinesGreen
hi! link diffNewFile LinesRed

hi! link diffAdded   LinesGreen
hi! link diffLine    LinesCyanItalic
hi! link diffRemoved LinesRed
" }}}

" HTML: {{{
hi! link htmlTag         LinesFg
hi! link htmlArg         LinesGreenItalic
hi! link htmlTitle       LinesFg
hi! link htmlH1          LinesFg
hi! link htmlSpecialChar LinesPurple
" }}}

" JavaScript: {{{
hi! link javaScriptBraces   Delimiter
hi! link javaScriptNumber   Constant
hi! link javaScriptNull     Constant
hi! link javaScriptFunction Keyword

" pangloss/vim-javascript
hi! link jsArrowFunction           Operator
hi! link jsBuiltins                LinesCyan
hi! link jsClassDefinition         LinesCyan
hi! link jsClassMethodType         Keyword
hi! link jsDestructuringAssignment LinesOrangeItalic
hi! link jsDocParam                LinesOrangeItalic
hi! link jsDocTags                 Keyword
hi! link jsDocType                 Type
hi! link jsDocTypeBrackets         LinesCyan
hi! link jsFuncArgOperator         Operator
hi! link jsFuncArgs                LinesOrangeItalic
hi! link jsFunction                Keyword
hi! link jsNull                    Constant
hi! link jsObjectColon             LinesPink
hi! link jsSuper                   LinesPurpleItalic
hi! link jsTemplateBraces          Special
hi! link jsThis                    LinesPurpleItalic
hi! link jsUndefined               Constant

" maxmellon/vim-jsx-pretty
hi! link jsxTag             Keyword
hi! link jsxTagName         Keyword
hi! link jsxComponentName   Type
hi! link jsxCloseTag        Type
hi! link jsxAttrib          LinesGreenItalic
hi! link jsxCloseString     Identifier
hi! link jsxOpenPunct       Identifier
" }}}

" JSON: {{{
hi! link jsonKeyword      LinesCyan
hi! link jsonKeywordMatch LinesPink
" }}}

" Lua: {{{
hi! link luaFunc  LinesCyan
hi! link luaTable LinesFg

" tbastos/vim-lua
hi! link luaBraces       LinesFg
hi! link luaBuiltIn      Constant
hi! link luaDocTag       Keyword
hi! link luaErrHand      LinesCyan
hi! link luaFuncArgName  LinesOrangeItalic
hi! link luaFuncCall     Function
hi! link luaLocal        Keyword
hi! link luaSpecialTable Constant
hi! link luaSpecialValue LinesCyan
" }}}

" Markdown: {{{
hi! link markdownBlockquote        LinesCyan
hi! link markdownBold              LinesOrangeBold
hi! link markdownBoldItalic        LinesOrangeBoldItalic
hi! link markdownCodeBlock         LinesGreen
hi! link markdownCode              LinesGreen
hi! link markdownCodeDelimiter     LinesGreen
hi! link markdownH1                LinesPurpleBold
hi! link markdownH2                markdownH1
hi! link markdownH3                markdownH1
hi! link markdownH4                markdownH1
hi! link markdownH5                markdownH1
hi! link markdownH6                markdownH1
hi! link markdownHeadingDelimiter  markdownH1
hi! link markdownHeadingRule       markdownH1
hi! link markdownItalic            LinesYellowItalic
hi! link markdownLinkText          LinesPink
hi! link markdownListMarker        LinesCyan
hi! link markdownOrderedListMarker LinesCyan
hi! link markdownRule              LinesComment
hi! link markdownUrl               LinesLink

" plasticboy/vim-markdown
hi! link htmlBold       LinesOrangeBold
hi! link htmlBoldItalic LinesOrangeBoldItalic
hi! link htmlH1         LinesPurpleBold
hi! link htmlItalic     LinesYellowItalic
hi! link mkdBlockquote  LinesYellowItalic
hi! link mkdBold        LinesOrangeBold
hi! link mkdBoldItalic  LinesOrangeBoldItalic
hi! link mkdCode        LinesGreen
hi! link mkdCodeEnd     LinesGreen
hi! link mkdCodeStart   LinesGreen
hi! link mkdHeading     LinesPurpleBold
hi! link mkdInlineUrl   LinesLink
hi! link mkdItalic      LinesYellowItalic
hi! link mkdLink        LinesPink
hi! link mkdListItem    LinesCyan
hi! link mkdRule        LinesComment
hi! link mkdUrl         LinesLink
" }}}

" OCaml: {{{
hi! link ocamlModule  Type
hi! link ocamlModPath Normal
hi! link ocamlLabel   LinesOrangeItalic
" }}}

" Perl: {{{
" Regex
hi! link perlMatchStartEnd       LinesRed

" Builtin functions
hi! link perlOperator            LinesCyan
hi! link perlStatementFiledesc   LinesCyan
hi! link perlStatementFiles      LinesCyan
hi! link perlStatementFlow       LinesCyan
hi! link perlStatementHash       LinesCyan
hi! link perlStatementIOfunc     LinesCyan
hi! link perlStatementIPC        LinesCyan
hi! link perlStatementList       LinesCyan
hi! link perlStatementMisc       LinesCyan
hi! link perlStatementNetwork    LinesCyan
hi! link perlStatementNumeric    LinesCyan
hi! link perlStatementProc       LinesCyan
hi! link perlStatementPword      LinesCyan
hi! link perlStatementRegexp     LinesCyan
hi! link perlStatementScalar     LinesCyan
hi! link perlStatementSocket     LinesCyan
hi! link perlStatementTime       LinesCyan
hi! link perlStatementVector     LinesCyan

" Highlighting for quoting constructs, tied to existing option in vim-perl
if get(g:, 'perl_string_as_statement', 0)
  hi! link perlStringStartEnd LinesRed
endif

" Signatures
hi! link perlSignature           LinesOrangeItalic
hi! link perlSubPrototype        LinesOrangeItalic

" Hash keys
hi! link perlVarSimpleMemberName LinesPurple
" }}}

" PHP: {{{
hi! link phpClass           Type
hi! link phpClasses         Type
hi! link phpDocTags         LinesCyanItalic
hi! link phpFunction        Function
hi! link phpParent          Normal
hi! link phpSpecialFunction LinesCyan
" }}}

" PlantUML: {{{
hi! link plantumlClassPrivate              SpecialKey
hi! link plantumlClassProtected            LinesOrange
hi! link plantumlClassPublic               Function
hi! link plantumlColonLine                 String
hi! link plantumlDirectedOrVerticalArrowLR Constant
hi! link plantumlDirectedOrVerticalArrowRL Constant
hi! link plantumlHorizontalArrow           Constant
hi! link plantumlSkinParamKeyword          LinesCyan
hi! link plantumlTypeKeyword               Keyword
" }}}

" PureScript: {{{
hi! link purescriptModule Type
hi! link purescriptImport LinesCyan
hi! link purescriptImportAs LinesCyan
hi! link purescriptOperator Operator
hi! link purescriptBacktick Operator
" }}}

" Python: {{{
hi! link pythonBuiltinObj    Type
hi! link pythonBuiltinObject Type
hi! link pythonBuiltinType   Type
hi! link pythonClassVar      LinesPurpleItalic
hi! link pythonExClass       Type
hi! link pythonNone          Type
hi! link pythonRun           Comment
" }}}

" reStructuredText: {{{
hi! link rstComment                             Comment
hi! link rstTransition                          Comment
hi! link rstCodeBlock                           LinesGreen
hi! link rstInlineLiteral                       LinesGreen
hi! link rstLiteralBlock                        LinesGreen
hi! link rstQuotedLiteralBlock                  LinesGreen
hi! link rstStandaloneHyperlink                 LinesLink
hi! link rstStrongEmphasis                      LinesOrangeBold
hi! link rstSections                            LinesPurpleBold
hi! link rstEmphasis                            LinesYellowItalic
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

hi! link rubyBlockArgument          LinesOrangeItalic
hi! link rubyBlockParameter         LinesOrangeItalic
hi! link rubyCurlyBlock             LinesPink
hi! link rubyGlobalVariable         LinesPurple
hi! link rubyInstanceVariable       LinesPurpleItalic
hi! link rubyInterpolationDelimiter LinesPink
hi! link rubyRegexpDelimiter        LinesRed
hi! link rubyStringDelimiter        LinesYellow
" }}}

" Rust: {{{
hi! link rustCommentLineDoc Comment
" }}}

" Sass: {{{
hi! link sassClass                  cssClassName
hi! link sassClassChar              cssClassNameDot
hi! link sassId                     cssIdentifier
hi! link sassIdChar                 cssIdentifier
hi! link sassInterpolationDelimiter LinesPink
hi! link sassMixinName              Function
hi! link sassProperty               cssProp
hi! link sassVariableAssignment     Operator
" }}}

" Shell: {{{
hi! link shCommandSub NONE
hi! link shEscape     LinesRed
hi! link shParen      NONE
hi! link shParenError NONE
" }}}

" Tex: {{{
hi! link texBeginEndName  LinesOrangeItalic
hi! link texBoldItalStyle LinesOrangeBoldItalic
hi! link texBoldStyle     LinesOrangeBold
hi! link texInputFile     LinesOrangeItalic
hi! link texItalStyle     LinesYellowItalic
hi! link texLigature      LinesPurple
hi! link texMath          LinesPurple
hi! link texMathMatcher   LinesPurple
hi! link texMathSymbol    LinesPurple
hi! link texSpecialChar   LinesPurple
hi! link texSubscripts    LinesPurple
hi! link texTitle         LinesFgBold
" }}}

" Typescript: {{{
hi! link typescriptAliasDeclaration       Type
hi! link typescriptArrayMethod            Function
hi! link typescriptArrowFunc              Operator
hi! link typescriptArrowFuncArg           LinesOrangeItalic
hi! link typescriptAssign                 Operator
hi! link typescriptBOMWindowProp          Constant
hi! link typescriptBinaryOp               Operator
hi! link typescriptBraces                 Delimiter
hi! link typescriptCall                   typescriptArrowFuncArg
hi! link typescriptClassHeritage          Type
hi! link typescriptClassName              Type
hi! link typescriptDateMethod             LinesCyan
hi! link typescriptDateStaticMethod       Function
hi! link typescriptDecorator              LinesGreenItalic
hi! link typescriptDefaultParam           Operator
hi! link typescriptES6SetMethod           LinesCyan
hi! link typescriptEndColons              Delimiter
hi! link typescriptEnum                   Type
hi! link typescriptEnumKeyword            Keyword
hi! link typescriptFuncComma              Delimiter
hi! link typescriptFuncKeyword            Keyword
hi! link typescriptFuncType               LinesOrangeItalic
hi! link typescriptFuncTypeArrow          Operator
hi! link typescriptGlobal                 Type
hi! link typescriptGlobalMethod           LinesCyan
hi! link typescriptGlobalObjects          Type
hi! link typescriptIdentifier             LinesPurpleItalic
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
hi! link typescriptParamImpl              LinesOrangeItalic
hi! link typescriptParens                 Delimiter
hi! link typescriptPredefinedType         Type
hi! link typescriptRestOrSpread           Operator
hi! link typescriptTernaryOp              Operator
hi! link typescriptTypeAnnotation         Special
hi! link typescriptTypeCast               Operator
hi! link typescriptTypeParameter          LinesOrangeItalic
hi! link typescriptTypeReference          Type
hi! link typescriptUnaryOp                Operator
hi! link typescriptVariable               Keyword

hi! link tsxAttrib           LinesGreenItalic
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
hi! link xmlAttrib  LinesGreenItalic
hi! link xmlEqual   Operator
hi! link xmlTag     Delimiter
hi! link xmlTagName Statement

" Fixes missing highlight over end tags
syn region xmlTagName
	\ matchgroup=xmlTag start=+</[^ /!?<>"']\@=+
	\ matchgroup=xmlTag end=+>+
" }}}

" YAML: {{{
hi! link yamlAlias           LinesGreenItalicUnderline
hi! link yamlAnchor          LinesPinkItalic
hi! link yamlBlockMappingKey LinesCyan
hi! link yamlFlowCollection  LinesPink
hi! link yamlFlowIndicator   Delimiter
hi! link yamlNodeTag         LinesPink
hi! link yamlPlainScalar     LinesYellow
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
    \ 'hl+':     ['fg', 'LinesOrange'],
    \ 'info':    ['fg', 'LinesPurple'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'LinesGreen'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'],
    \}
endif
" }}}

" dense-analysis/ale {{{
hi! link ALEError              LinesErrorLine
hi! link ALEWarning            LinesWarnLine
hi! link ALEInfo               LinesInfoLine

hi! link ALEErrorSign          LinesRed
hi! link ALEWarningSign        LinesOrange
hi! link ALEInfoSign           LinesCyan

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
  " those highlight groups when the defaults do not match the lines
  " specification.
  " https://github.com/nvim-treesitter/nvim-treesitter/blob/master/plugin/nvim-treesitter.vim

  " deprecated TS* highlight groups
  " see https://github.com/nvim-treesitter/nvim-treesitter/pull/3656
  " # Misc
  hi! link TSPunctSpecial Special
  " # Constants
  hi! link TSConstMacro Macro
  hi! link TSStringEscape Character
  hi! link TSSymbol LinesPurple
  hi! link TSAnnotation LinesYellow
  hi! link TSAttribute LinesGreenItalic
  " # Functions
  hi! link TSFuncBuiltin LinesCyan
  hi! link TSFuncMacro Function
  hi! link TSParameter LinesOrangeItalic
  hi! link TSParameterReference LinesOrange
  hi! link TSField LinesOrange
  hi! link TSConstructor LinesCyan
  " # Keywords
  hi! link TSLabel LinesPurpleItalic
  " # Variable
  hi! link TSVariableBuiltin LinesPurpleItalic
  " # Text
  hi! link TSStrong LinesFgBold
  hi! link TSEmphasis LinesFg
  hi! link TSUnderline Underlined
  hi! link TSTitle LinesYellow
  hi! link TSLiteral LinesYellow
  hi! link TSURI LinesYellow
  " HTML and JSX tag attributes. By default, this group is linked to TSProperty,
  " which in turn links to Identifer (white).
  hi! link TSTagAttribute LinesGreenItalic

  if has('nvim-0.8.1')
    " # Misc
    hi! link @punctuation.delimiter Delimiter
    hi! link @punctuation.bracket LinesFg
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
    hi! link @string.special.symbol LinesPurple
    hi! link @string.special.url Underlined
    hi! link @symbol LinesPurple
    hi! link @annotation LinesYellow
    hi! link @attribute LinesGreenItalic
    hi! link @namespace Structure
    hi! link @module Structure
    hi! link @module.builtin Special
    " # Functions
    hi! link @function.builtin LinesCyan
    hi! link @funcion.macro Function
    hi! link @function Function
    hi! link @parameter LinesOrangeItalic
    hi! link @parameter.reference LinesOrange
    hi! link @field LinesOrange
    hi! link @property LinesFg
    hi! link @constructor LinesCyan
    " # Keywords
    hi! link @label LinesPurpleItalic
    hi! link @keyword.function LinesPink
    hi! link @keyword.operator Operator
    hi! link @keyword Keyword
    hi! link @exception LinesPurple
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
    hi! link @variable LinesFg
    hi! link @variable.builtin LinesPurpleItalic
    hi! link @variable.parameter LinesOrangeItalic
    hi! link @variable.member  LinesOrange
    " # Text
    hi! link @text LinesFg
    hi! link @text.strong LinesFgBold
    hi! link @text.emphasis LinesFg
    hi! link @text.underline Underlined
    hi! link @text.title LinesYellow
    hi! link @text.literal LinesYellow
    hi! link @text.uri LinesYellow
    hi! link @text.diff.add DiffAdd
    hi! link @text.diff.delete DiffDelete

    hi! link @markup.strong LinesFgBold
    hi! link @markup.italic LinesFgItalic
    hi! link @markup.strikethrough LinesFgStrikethrough
    hi! link @markup.underline Underlined

    hi! link @markup Special
    hi! link @markup.heading LinesYellow
    hi! link @markup.link Underlined
    hi! link @markup.link.uri LinesYellow
    hi! link @markup.link.label SpecialChar
    hi! link @markup.raw LinesYellow
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
    hi! link @tag LinesCyan
    hi! link @tag.delimiter LinesFg
    " HTML and JSX tag attributes. By default, this group is linked to TSProperty,
    " which in turn links to Identifer (white).
    hi! link @tag.attribute LinesGreenItalic
  endif
  " }}}

  " hrsh7th/nvim-cmp {{{
  hi! link CmpItemAbbrDeprecated LinesError

  hi! link CmpItemAbbrMatch LinesCyan
  hi! link CmpItemAbbrMatchFuzzy LinesCyan

  hi! link CmpItemKindText LinesFg
  hi! link CmpItemKindMethod Function
  hi! link CmpItemKindFunction Function
  hi! link CmpItemKindConstructor LinesCyan
  hi! link CmpItemKindField LinesOrange
  hi! link CmpItemKindVariable LinesPurpleItalic
  hi! link CmpItemKindClass LinesCyan
  hi! link CmpItemKindInterface LinesCyan
  hi! link CmpItemKindModule LinesYellow
  hi! link CmpItemKindProperty LinesPink
  hi! link CmpItemKindUnit LinesFg
  hi! link CmpItemKindValue LinesYellow
  hi! link CmpItemKindEnum LinesPink
  hi! link CmpItemKindKeyword LinesPink
  hi! link CmpItemKindSnippet LinesFg
  hi! link CmpItemKindColor LinesYellow
  hi! link CmpItemKindFile LinesYellow
  hi! link CmpItemKindReference LinesOrange
  hi! link CmpItemKindFolder LinesYellow
  hi! link CmpItemKindEnumMember LinesPurple
  hi! link CmpItemKindConstant LinesPurple
  hi! link CmpItemKindStruct LinesPink
  hi! link CmpItemKindEvent LinesFg
  hi! link CmpItemKindOperator LinesPink
  hi! link CmpItemKindTypeParameter LinesCyan

  hi! link CmpItemMenu Comment
  " }}}

  " lewis6991/gitsigns.nvim {{{
  hi! link GitSignsAdd      DiffAdd
  hi! link GitSignsAddLn    DiffAdd
  hi! link GitSignsAddNr    DiffAdd
  hi! link GitSignsChange   DiffChange
  hi! link GitSignsChangeLn DiffChange
  hi! link GitSignsChangeNr DiffChange

  hi! link GitSignsDelete   LinesRed
  hi! link GitSignsDeleteLn LinesRed
  hi! link GitSignsDeleteNr LinesRed
  " }}}

endif
" }}}

" }}}

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0 et:
