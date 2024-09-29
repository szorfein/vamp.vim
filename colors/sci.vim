" Sci Theme: {{{
"
" https://github.com/zenorocha/sci-theme
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

let g:colors_name = 'sci'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" Palette: {{{2

let s:fg        = g:sci#palette.fg

let s:bglighter = g:sci#palette.bglighter
let s:bglight   = g:sci#palette.bglight
let s:bg        = g:sci#palette.bg
let s:bgdark    = g:sci#palette.bgdark
let s:bgdarker  = g:sci#palette.bgdarker

let s:comment   = g:sci#palette.comment
let s:selection = g:sci#palette.selection
let s:subtle    = g:sci#palette.subtle

let s:cyan      = g:sci#palette.cyan
let s:green     = g:sci#palette.green
let s:orange    = g:sci#palette.orange
let s:pink      = g:sci#palette.pink
let s:purple    = g:sci#palette.purple
let s:red       = g:sci#palette.red
let s:yellow    = g:sci#palette.yellow

let s:none      = ['NONE', 'NONE']

if has('nvim')
  for s:i in range(16)
    let g:terminal_color_{s:i} = g:sci#palette['color_' . s:i]
  endfor
endif

if has('terminal')
  let g:terminal_ansi_colors = []
  for s:i in range(16)
    call add(g:terminal_ansi_colors, g:sci#palette['color_' . s:i])
  endfor
endif

" }}}2
" User Configuration: {{{2

if !exists('g:sci_bold')
  let g:sci_bold = 1
endif

if !exists('g:sci_italic')
  let g:sci_italic = 1
endif

if !exists('g:sci_strikethrough')
  let g:sci_strikethrough = 1
endif

if !exists('g:sci_underline')
  let g:sci_underline = 1
endif

if !exists('g:sci_undercurl')
  let g:sci_undercurl = g:sci_underline
endif

if !exists('g:sci_full_special_attrs_support')
  let g:sci_full_special_attrs_support = has('gui_running')
endif

if !exists('g:sci_inverse')
  let g:sci_inverse = 1
endif

if !exists('g:sci_colorterm')
  let g:sci_colorterm = 1
endif

if !exists('g:sci_high_contrast_diff')
  let g:sci_high_contrast_diff = 0
endif

"}}}2
" Script Helpers: {{{2

let s:attrs = {
      \ 'bold': g:sci_bold == 1 ? 'bold' : 0,
      \ 'italic': g:sci_italic == 1 ? 'italic' : 0,
      \ 'strikethrough': g:sci_strikethrough == 1 ? 'strikethrough' : 0,
      \ 'underline': g:sci_underline == 1 ? 'underline' : 0,
      \ 'undercurl': g:sci_undercurl == 1 ? 'undercurl' : 0,
      \ 'inverse': g:sci_inverse == 1 ? 'inverse' : 0,
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
  " the global variable `g:sci_full_special_attrs_support` explicitly if the
  " default behavior is not desirable.
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !g:sci_full_special_attrs_support
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
" Sci Highlight Groups: {{{2

call s:h('SciBgLight', s:none, s:bglight)
call s:h('SciBgLighter', s:none, s:bglighter)
call s:h('SciBgDark', s:none, s:bgdark)
call s:h('SciBgDarker', s:none, s:bgdarker)

call s:h('SciFg', s:fg)
call s:h('SciFgUnderline', s:fg, s:none, [s:attrs.underline])
call s:h('SciFgBold', s:fg, s:none, [s:attrs.bold])
call s:h('SciFgStrikethrough', s:fg, s:none, [s:attrs.strikethrough])

call s:h('SciComment', s:comment)
call s:h('SciCommentBold', s:comment, s:none, [s:attrs.bold])

call s:h('SciSelection', s:none, s:selection)

call s:h('SciSubtle', s:subtle)

call s:h('SciCyan', s:cyan)
call s:h('SciCyanItalic', s:cyan, s:none, [s:attrs.italic])

call s:h('SciGreen', s:green)
call s:h('SciGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('SciGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('SciGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])

call s:h('SciOrange', s:orange)
call s:h('SciOrangeBold', s:orange, s:none, [s:attrs.bold])
call s:h('SciOrangeItalic', s:orange, s:none, [s:attrs.italic])
call s:h('SciOrangeBoldItalic', s:orange, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('SciOrangeInverse', s:bg, s:orange)

call s:h('SciPink', s:pink)
call s:h('SciPinkItalic', s:pink, s:none, [s:attrs.italic])

call s:h('SciPurple', s:purple)
call s:h('SciPurpleBold', s:purple, s:none, [s:attrs.bold])
call s:h('SciPurpleItalic', s:purple, s:none, [s:attrs.italic])

call s:h('SciRed', s:red)
call s:h('SciRedInverse', s:fg, s:red)

call s:h('SciYellow', s:yellow)
call s:h('SciYellowItalic', s:yellow, s:none, [s:attrs.italic])

call s:h('SciError', s:red, s:none, [], s:red)

call s:h('SciErrorLine', s:none, s:none, [s:attrs.undercurl], s:red)
call s:h('SciWarnLine', s:none, s:none, [s:attrs.undercurl], s:orange)
call s:h('SciInfoLine', s:none, s:none, [s:attrs.undercurl], s:cyan)

call s:h('SciTodo', s:cyan, s:none, [s:attrs.bold, s:attrs.inverse])
call s:h('SciSearch', s:green, s:none, [s:attrs.inverse])
call s:h('SciBoundary', s:comment, s:bgdark)
call s:h('SciWinSeparator', s:comment, s:bgdark)
call s:h('SciLink', s:cyan, s:none, [s:attrs.underline])

if g:sci_high_contrast_diff
  call s:h('SciDiffChange', s:yellow, s:purple)
  call s:h('SciDiffDelete', s:bgdark, s:red)
else
  call s:h('SciDiffChange', s:orange, s:none)
  call s:h('SciDiffDelete', s:red, s:bgdark)
endif

call s:h('SciDiffText', s:bg, s:orange)
call s:h('SciInlayHint', s:comment, s:bgdark)

" }}}2

" }}}
" User Interface: {{{

set background=dark

" Required as some plugins will overwrite
call s:h('Normal', s:fg, g:sci_colorterm || has('gui_running') ? s:bg : s:none )
call s:h('StatusLine', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineNC', s:none, s:bglight)
call s:h('StatusLineTerm', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineTermNC', s:none, s:bglight)
call s:h('WildMenu', s:bg, s:purple, [s:attrs.bold])
call s:h('CursorLine', s:none, s:subtle)

hi! link ColorColumn  SciBgDark
hi! link CursorColumn CursorLine
hi! link CursorLineNr SciYellow
hi! link DiffAdd      SciGreen
hi! link DiffAdded    DiffAdd
hi! link DiffChange   SciDiffChange
hi! link DiffDelete   SciDiffDelete
hi! link DiffRemoved  DiffDelete
hi! link DiffText     SciDiffText
hi! link Directory    SciPurpleBold
hi! link ErrorMsg     SciRedInverse
hi! link FoldColumn   SciSubtle
hi! link Folded       SciBoundary
hi! link IncSearch    SciOrangeInverse
call s:h('LineNr', s:comment)
hi! link MoreMsg      SciFgBold
hi! link NonText      SciSubtle
hi! link Pmenu        SciBgDark
hi! link PmenuSbar    SciBgDark
hi! link PmenuSel     SciSelection
hi! link PmenuThumb   SciSelection
call s:h('PmenuMatch', s:cyan, s:bgdark)
call s:h('PmenuMatchSel', s:cyan, s:selection)
hi! link Question     SciFgBold
hi! link Search       SciSearch
call s:h('SignColumn', s:comment)
hi! link TabLine      SciBoundary
hi! link TabLineFill  SciBgDark
hi! link TabLineSel   Normal
hi! link Title        SciGreenBold
hi! link VertSplit    SciWinSeparator
hi! link Visual       SciSelection
hi! link VisualNOS    Visual
hi! link WarningMsg   SciOrangeInverse

" }}}
" Syntax: {{{

" Required as some plugins will overwrite
call s:h('MatchParen', s:green, s:none, [s:attrs.underline])
call s:h('Conceal', s:cyan, s:none)

" Neovim uses SpecialKey for escape characters only. Vim uses it for that, plus whitespace.
if has('nvim')
  hi! link SpecialKey SciRed
  hi! link LspReferenceText SciSelection
  hi! link LspReferenceRead SciSelection
  hi! link LspReferenceWrite SciSelection
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
  hi! link LspInlayHint SciInlayHint

  hi! link DiagnosticInfo SciCyan
  hi! link DiagnosticHint SciCyan
  hi! link DiagnosticError SciError
  hi! link DiagnosticWarn SciOrange
  hi! link DiagnosticUnderlineError SciErrorLine
  hi! link DiagnosticUnderlineHint SciInfoLine
  hi! link DiagnosticUnderlineInfo SciInfoLine
  hi! link DiagnosticUnderlineWarn SciWarnLine

  hi! link WinSeparator SciWinSeparator
  hi! link NormalFloat Pmenu

  if has('nvim-0.9')
    hi! link  @lsp.type.class SciCyan
    hi! link  @lsp.type.decorator SciGreen
    hi! link  @lsp.type.enum SciCyan
    hi! link  @lsp.type.enumMember SciPurple
    hi! link  @lsp.type.function SciGreen
    hi! link  @lsp.type.interface SciCyan
    hi! link  @lsp.type.macro SciCyan
    hi! link  @lsp.type.method SciGreen
    hi! link  @lsp.type.namespace SciCyan
    hi! link  @lsp.type.parameter SciOrangeItalic
    hi! link  @lsp.type.property SciOrange
    hi! link  @lsp.type.struct SciCyan
    hi! link  @lsp.type.type SciCyanItalic
    hi! link  @lsp.type.typeParameter SciPink
    hi! link  @lsp.type.variable SciFg
  endif
else
  hi! link SpecialKey SciPink
endif

hi! link Comment SciComment
hi! link Underlined SciFgUnderline
hi! link Todo SciTodo

hi! link Error SciError
hi! link SpellBad SciErrorLine
hi! link SpellLocal SciWarnLine
hi! link SpellCap SciInfoLine
hi! link SpellRare SciInfoLine

hi! link Constant SciPurple
hi! link String SciYellow
hi! link Character SciPink
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Constant

hi! link Identifier SciFg
hi! link Function SciGreen

hi! link Statement SciPink
hi! link Conditional SciPink
hi! link Repeat SciPink
hi! link Label SciPink
hi! link Operator SciPink
hi! link Keyword SciPink
hi! link Exception SciPink

hi! link PreProc SciPink
hi! link Include SciPink
hi! link Define SciPink
hi! link Macro SciPink
hi! link PreCondit SciPink
hi! link StorageClass SciPink
hi! link Structure SciPink
hi! link Typedef SciPink

hi! link Type SciCyanItalic

hi! link Delimiter SciFg

hi! link Special SciPink
hi! link SpecialComment SciCyanItalic
hi! link Tag SciCyan
hi! link helpHyperTextJump SciLink
hi! link helpCommand SciPurple
hi! link helpExample SciGreen
hi! link helpBacktick Special

" }}}

" Languages: {{{

" CSS: {{{
hi! link cssAttrComma         Delimiter
hi! link cssAttrRegion        SciPink
hi! link cssAttributeSelector SciGreenItalic
hi! link cssBraces            Delimiter
hi! link cssFunctionComma     Delimiter
hi! link cssNoise             SciPink
hi! link cssProp              SciCyan
hi! link cssPseudoClass       SciPink
hi! link cssPseudoClassId     SciGreenItalic
hi! link cssUnitDecorators    SciPink
hi! link cssVendor            SciGreenItalic
" }}}

" Git Commit: {{{
" The following two are misnomers. Colors are correct.
hi! link diffFile    SciGreen
hi! link diffNewFile SciRed

hi! link diffAdded   SciGreen
hi! link diffLine    SciCyanItalic
hi! link diffRemoved SciRed
" }}}

" HTML: {{{
hi! link htmlTag         SciFg
hi! link htmlArg         SciGreenItalic
hi! link htmlTitle       SciFg
hi! link htmlH1          SciFg
hi! link htmlSpecialChar SciPurple
" }}}

" JavaScript: {{{
hi! link javaScriptBraces   Delimiter
hi! link javaScriptNumber   Constant
hi! link javaScriptNull     Constant
hi! link javaScriptFunction Keyword

" pangloss/vim-javascript
hi! link jsArrowFunction           Operator
hi! link jsBuiltins                SciCyan
hi! link jsClassDefinition         SciCyan
hi! link jsClassMethodType         Keyword
hi! link jsDestructuringAssignment SciOrangeItalic
hi! link jsDocParam                SciOrangeItalic
hi! link jsDocTags                 Keyword
hi! link jsDocType                 Type
hi! link jsDocTypeBrackets         SciCyan
hi! link jsFuncArgOperator         Operator
hi! link jsFuncArgs                SciOrangeItalic
hi! link jsFunction                Keyword
hi! link jsNull                    Constant
hi! link jsObjectColon             SciPink
hi! link jsSuper                   SciPurpleItalic
hi! link jsTemplateBraces          Special
hi! link jsThis                    SciPurpleItalic
hi! link jsUndefined               Constant

" maxmellon/vim-jsx-pretty
hi! link jsxTag             Keyword
hi! link jsxTagName         Keyword
hi! link jsxComponentName   Type
hi! link jsxCloseTag        Type
hi! link jsxAttrib          SciGreenItalic
hi! link jsxCloseString     Identifier
hi! link jsxOpenPunct       Identifier
" }}}

" JSON: {{{
hi! link jsonKeyword      SciCyan
hi! link jsonKeywordMatch SciPink
" }}}

" Lua: {{{
hi! link luaFunc  SciCyan
hi! link luaTable SciFg

" tbastos/vim-lua
hi! link luaBraces       SciFg
hi! link luaBuiltIn      Constant
hi! link luaDocTag       Keyword
hi! link luaErrHand      SciCyan
hi! link luaFuncArgName  SciOrangeItalic
hi! link luaFuncCall     Function
hi! link luaLocal        Keyword
hi! link luaSpecialTable Constant
hi! link luaSpecialValue SciCyan
" }}}

" Markdown: {{{
hi! link markdownBlockquote        SciCyan
hi! link markdownBold              SciOrangeBold
hi! link markdownBoldItalic        SciOrangeBoldItalic
hi! link markdownCodeBlock         SciGreen
hi! link markdownCode              SciGreen
hi! link markdownCodeDelimiter     SciGreen
hi! link markdownH1                SciPurpleBold
hi! link markdownH2                markdownH1
hi! link markdownH3                markdownH1
hi! link markdownH4                markdownH1
hi! link markdownH5                markdownH1
hi! link markdownH6                markdownH1
hi! link markdownHeadingDelimiter  markdownH1
hi! link markdownHeadingRule       markdownH1
hi! link markdownItalic            SciYellowItalic
hi! link markdownLinkText          SciPink
hi! link markdownListMarker        SciCyan
hi! link markdownOrderedListMarker SciCyan
hi! link markdownRule              SciComment
hi! link markdownUrl               SciLink

" plasticboy/vim-markdown
hi! link htmlBold       SciOrangeBold
hi! link htmlBoldItalic SciOrangeBoldItalic
hi! link htmlH1         SciPurpleBold
hi! link htmlItalic     SciYellowItalic
hi! link mkdBlockquote  SciYellowItalic
hi! link mkdBold        SciOrangeBold
hi! link mkdBoldItalic  SciOrangeBoldItalic
hi! link mkdCode        SciGreen
hi! link mkdCodeEnd     SciGreen
hi! link mkdCodeStart   SciGreen
hi! link mkdHeading     SciPurpleBold
hi! link mkdInlineUrl   SciLink
hi! link mkdItalic      SciYellowItalic
hi! link mkdLink        SciPink
hi! link mkdListItem    SciCyan
hi! link mkdRule        SciComment
hi! link mkdUrl         SciLink
" }}}

" OCaml: {{{
hi! link ocamlModule  Type
hi! link ocamlModPath Normal
hi! link ocamlLabel   SciOrangeItalic
" }}}

" Perl: {{{
" Regex
hi! link perlMatchStartEnd       SciRed

" Builtin functions
hi! link perlOperator            SciCyan
hi! link perlStatementFiledesc   SciCyan
hi! link perlStatementFiles      SciCyan
hi! link perlStatementFlow       SciCyan
hi! link perlStatementHash       SciCyan
hi! link perlStatementIOfunc     SciCyan
hi! link perlStatementIPC        SciCyan
hi! link perlStatementList       SciCyan
hi! link perlStatementMisc       SciCyan
hi! link perlStatementNetwork    SciCyan
hi! link perlStatementNumeric    SciCyan
hi! link perlStatementProc       SciCyan
hi! link perlStatementPword      SciCyan
hi! link perlStatementRegexp     SciCyan
hi! link perlStatementScalar     SciCyan
hi! link perlStatementSocket     SciCyan
hi! link perlStatementTime       SciCyan
hi! link perlStatementVector     SciCyan

" Highlighting for quoting constructs, tied to existing option in vim-perl
if get(g:, 'perl_string_as_statement', 0)
  hi! link perlStringStartEnd SciRed
endif

" Signatures
hi! link perlSignature           SciOrangeItalic
hi! link perlSubPrototype        SciOrangeItalic

" Hash keys
hi! link perlVarSimpleMemberName SciPurple
" }}}

" PHP: {{{
hi! link phpClass           Type
hi! link phpClasses         Type
hi! link phpDocTags         SciCyanItalic
hi! link phpFunction        Function
hi! link phpParent          Normal
hi! link phpSpecialFunction SciCyan
" }}}

" PlantUML: {{{
hi! link plantumlClassPrivate              SpecialKey
hi! link plantumlClassProtected            SciOrange
hi! link plantumlClassPublic               Function
hi! link plantumlColonLine                 String
hi! link plantumlDirectedOrVerticalArrowLR Constant
hi! link plantumlDirectedOrVerticalArrowRL Constant
hi! link plantumlHorizontalArrow           Constant
hi! link plantumlSkinParamKeyword          SciCyan
hi! link plantumlTypeKeyword               Keyword
" }}}

" PureScript: {{{
hi! link purescriptModule Type
hi! link purescriptImport SciCyan
hi! link purescriptImportAs SciCyan
hi! link purescriptOperator Operator
hi! link purescriptBacktick Operator
" }}}

" Python: {{{
hi! link pythonBuiltinObj    Type
hi! link pythonBuiltinObject Type
hi! link pythonBuiltinType   Type
hi! link pythonClassVar      SciPurpleItalic
hi! link pythonExClass       Type
hi! link pythonNone          Type
hi! link pythonRun           Comment
" }}}

" reStructuredText: {{{
hi! link rstComment                             Comment
hi! link rstTransition                          Comment
hi! link rstCodeBlock                           SciGreen
hi! link rstInlineLiteral                       SciGreen
hi! link rstLiteralBlock                        SciGreen
hi! link rstQuotedLiteralBlock                  SciGreen
hi! link rstStandaloneHyperlink                 SciLink
hi! link rstStrongEmphasis                      SciOrangeBold
hi! link rstSections                            SciPurpleBold
hi! link rstEmphasis                            SciYellowItalic
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

hi! link rubyBlockArgument          SciOrangeItalic
hi! link rubyBlockParameter         SciOrangeItalic
hi! link rubyCurlyBlock             SciPink
hi! link rubyGlobalVariable         SciPurple
hi! link rubyInstanceVariable       SciPurpleItalic
hi! link rubyInterpolationDelimiter SciPink
hi! link rubyRegexpDelimiter        SciRed
hi! link rubyStringDelimiter        SciYellow
" }}}

" Rust: {{{
hi! link rustCommentLineDoc Comment
" }}}

" Sass: {{{
hi! link sassClass                  cssClassName
hi! link sassClassChar              cssClassNameDot
hi! link sassId                     cssIdentifier
hi! link sassIdChar                 cssIdentifier
hi! link sassInterpolationDelimiter SciPink
hi! link sassMixinName              Function
hi! link sassProperty               cssProp
hi! link sassVariableAssignment     Operator
" }}}

" Shell: {{{
hi! link shCommandSub NONE
hi! link shEscape     SciRed
hi! link shParen      NONE
hi! link shParenError NONE
" }}}

" Tex: {{{
hi! link texBeginEndName  SciOrangeItalic
hi! link texBoldItalStyle SciOrangeBoldItalic
hi! link texBoldStyle     SciOrangeBold
hi! link texInputFile     SciOrangeItalic
hi! link texItalStyle     SciYellowItalic
hi! link texLigature      SciPurple
hi! link texMath          SciPurple
hi! link texMathMatcher   SciPurple
hi! link texMathSymbol    SciPurple
hi! link texSpecialChar   SciPurple
hi! link texSubscripts    SciPurple
hi! link texTitle         SciFgBold
" }}}

" Typescript: {{{
hi! link typescriptAliasDeclaration       Type
hi! link typescriptArrayMethod            Function
hi! link typescriptArrowFunc              Operator
hi! link typescriptArrowFuncArg           SciOrangeItalic
hi! link typescriptAssign                 Operator
hi! link typescriptBOMWindowProp          Constant
hi! link typescriptBinaryOp               Operator
hi! link typescriptBraces                 Delimiter
hi! link typescriptCall                   typescriptArrowFuncArg
hi! link typescriptClassHeritage          Type
hi! link typescriptClassName              Type
hi! link typescriptDateMethod             SciCyan
hi! link typescriptDateStaticMethod       Function
hi! link typescriptDecorator              SciGreenItalic
hi! link typescriptDefaultParam           Operator
hi! link typescriptES6SetMethod           SciCyan
hi! link typescriptEndColons              Delimiter
hi! link typescriptEnum                   Type
hi! link typescriptEnumKeyword            Keyword
hi! link typescriptFuncComma              Delimiter
hi! link typescriptFuncKeyword            Keyword
hi! link typescriptFuncType               SciOrangeItalic
hi! link typescriptFuncTypeArrow          Operator
hi! link typescriptGlobal                 Type
hi! link typescriptGlobalMethod           SciCyan
hi! link typescriptGlobalObjects          Type
hi! link typescriptIdentifier             SciPurpleItalic
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
hi! link typescriptParamImpl              SciOrangeItalic
hi! link typescriptParens                 Delimiter
hi! link typescriptPredefinedType         Type
hi! link typescriptRestOrSpread           Operator
hi! link typescriptTernaryOp              Operator
hi! link typescriptTypeAnnotation         Special
hi! link typescriptTypeCast               Operator
hi! link typescriptTypeParameter          SciOrangeItalic
hi! link typescriptTypeReference          Type
hi! link typescriptUnaryOp                Operator
hi! link typescriptVariable               Keyword

hi! link tsxAttrib           SciGreenItalic
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
hi! link xmlAttrib  SciGreenItalic
hi! link xmlEqual   Operator
hi! link xmlTag     Delimiter
hi! link xmlTagName Statement

" Fixes missing highlight over end tags
syn region xmlTagName
	\ matchgroup=xmlTag start=+</[^ /!?<>"']\@=+
	\ matchgroup=xmlTag end=+>+
" }}}

" YAML: {{{
hi! link yamlAlias           SciGreenItalicUnderline
hi! link yamlAnchor          SciPinkItalic
hi! link yamlBlockMappingKey SciCyan
hi! link yamlFlowCollection  SciPink
hi! link yamlFlowIndicator   Delimiter
hi! link yamlNodeTag         SciPink
hi! link yamlPlainScalar     SciYellow
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
    \ 'hl+':     ['fg', 'SciOrange'],
    \ 'info':    ['fg', 'SciPurple'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'SciGreen'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'],
    \}
endif
" }}}

" dense-analysis/ale {{{
hi! link ALEError              SciErrorLine
hi! link ALEWarning            SciWarnLine
hi! link ALEInfo               SciInfoLine

hi! link ALEErrorSign          SciRed
hi! link ALEWarningSign        SciOrange
hi! link ALEInfoSign           SciCyan

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
  " those highlight groups when the defaults do not match the sci
  " specification.
  " https://github.com/nvim-treesitter/nvim-treesitter/blob/master/plugin/nvim-treesitter.vim

  " deprecated TS* highlight groups
  " see https://github.com/nvim-treesitter/nvim-treesitter/pull/3656
  " # Misc
  hi! link TSPunctSpecial Special
  " # Constants
  hi! link TSConstMacro Macro
  hi! link TSStringEscape Character
  hi! link TSSymbol SciPurple
  hi! link TSAnnotation SciYellow
  hi! link TSAttribute SciGreenItalic
  " # Functions
  hi! link TSFuncBuiltin SciCyan
  hi! link TSFuncMacro Function
  hi! link TSParameter SciOrangeItalic
  hi! link TSParameterReference SciOrange
  hi! link TSField SciOrange
  hi! link TSConstructor SciCyan
  " # Keywords
  hi! link TSLabel SciPurpleItalic
  " # Variable
  hi! link TSVariableBuiltin SciPurpleItalic
  " # Text
  hi! link TSStrong SciFgBold
  hi! link TSEmphasis SciFg
  hi! link TSUnderline Underlined
  hi! link TSTitle SciYellow
  hi! link TSLiteral SciYellow
  hi! link TSURI SciYellow
  " HTML and JSX tag attributes. By default, this group is linked to TSProperty,
  " which in turn links to Identifer (white).
  hi! link TSTagAttribute SciGreenItalic

  if has('nvim-0.8.1')
    " # Misc
    hi! link @punctuation.delimiter Delimiter
    hi! link @punctuation.bracket SciFg
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
    hi! link @string.special.symbol SciPurple
    hi! link @string.special.url Underlined
    hi! link @symbol SciPurple
    hi! link @annotation SciYellow
    hi! link @attribute SciGreenItalic
    hi! link @namespace Structure
    hi! link @module Structure
    hi! link @module.builtin Special
    " # Functions
    hi! link @function.builtin SciCyan
    hi! link @funcion.macro Function
    hi! link @function Function
    hi! link @parameter SciOrangeItalic
    hi! link @parameter.reference SciOrange
    hi! link @field SciOrange
    hi! link @property SciFg
    hi! link @constructor SciCyan
    " # Keywords
    hi! link @label SciPurpleItalic
    hi! link @keyword.function SciPink
    hi! link @keyword.operator Operator
    hi! link @keyword Keyword
    hi! link @exception SciPurple
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
    hi! link @variable SciFg
    hi! link @variable.builtin SciPurpleItalic
    hi! link @variable.parameter SciOrangeItalic
    hi! link @variable.member  SciOrange
    " # Text
    hi! link @text SciFg
    hi! link @text.strong SciFgBold
    hi! link @text.emphasis SciFg
    hi! link @text.underline Underlined
    hi! link @text.title SciYellow
    hi! link @text.literal SciYellow
    hi! link @text.uri SciYellow
    hi! link @text.diff.add DiffAdd
    hi! link @text.diff.delete DiffDelete

    hi! link @markup.strong SciFgBold
    hi! link @markup.italic SciFgItalic
    hi! link @markup.strikethrough SciFgStrikethrough
    hi! link @markup.underline Underlined

    hi! link @markup Special
    hi! link @markup.heading SciYellow
    hi! link @markup.link Underlined
    hi! link @markup.link.uri SciYellow
    hi! link @markup.link.label SpecialChar
    hi! link @markup.raw SciYellow
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
    hi! link @tag SciCyan
    hi! link @tag.delimiter SciFg
    " HTML and JSX tag attributes. By default, this group is linked to TSProperty,
    " which in turn links to Identifer (white).
    hi! link @tag.attribute SciGreenItalic
  endif
  " }}}

  " hrsh7th/nvim-cmp {{{
  hi! link CmpItemAbbrDeprecated SciError

  hi! link CmpItemAbbrMatch SciCyan
  hi! link CmpItemAbbrMatchFuzzy SciCyan

  hi! link CmpItemKindText SciFg
  hi! link CmpItemKindMethod Function
  hi! link CmpItemKindFunction Function
  hi! link CmpItemKindConstructor SciCyan
  hi! link CmpItemKindField SciOrange
  hi! link CmpItemKindVariable SciPurpleItalic
  hi! link CmpItemKindClass SciCyan
  hi! link CmpItemKindInterface SciCyan
  hi! link CmpItemKindModule SciYellow
  hi! link CmpItemKindProperty SciPink
  hi! link CmpItemKindUnit SciFg
  hi! link CmpItemKindValue SciYellow
  hi! link CmpItemKindEnum SciPink
  hi! link CmpItemKindKeyword SciPink
  hi! link CmpItemKindSnippet SciFg
  hi! link CmpItemKindColor SciYellow
  hi! link CmpItemKindFile SciYellow
  hi! link CmpItemKindReference SciOrange
  hi! link CmpItemKindFolder SciYellow
  hi! link CmpItemKindEnumMember SciPurple
  hi! link CmpItemKindConstant SciPurple
  hi! link CmpItemKindStruct SciPink
  hi! link CmpItemKindEvent SciFg
  hi! link CmpItemKindOperator SciPink
  hi! link CmpItemKindTypeParameter SciCyan

  hi! link CmpItemMenu Comment
  " }}}

  " lewis6991/gitsigns.nvim {{{
  hi! link GitSignsAdd      DiffAdd
  hi! link GitSignsAddLn    DiffAdd
  hi! link GitSignsAddNr    DiffAdd
  hi! link GitSignsChange   DiffChange
  hi! link GitSignsChangeLn DiffChange
  hi! link GitSignsChangeNr DiffChange

  hi! link GitSignsDelete   SciRed
  hi! link GitSignsDeleteLn SciRed
  hi! link GitSignsDeleteNr SciRed
  " }}}

endif
" }}}

" }}}

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0 et:
