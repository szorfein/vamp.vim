" Miami Theme: {{{
"
" https://github.com/zenorocha/miami-theme
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

let g:colors_name = 'miami'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" Palette: {{{2

let s:fg        = g:miami#palette.fg

let s:bglighter = g:miami#palette.bglighter
let s:bglight   = g:miami#palette.bglight
let s:bg        = g:miami#palette.bg
let s:bgdark    = g:miami#palette.bgdark
let s:bgdarker  = g:miami#palette.bgdarker

let s:comment   = g:miami#palette.comment
let s:selection = g:miami#palette.selection
let s:subtle    = g:miami#palette.subtle

let s:cyan      = g:miami#palette.cyan
let s:green     = g:miami#palette.green
let s:orange    = g:miami#palette.orange
let s:pink      = g:miami#palette.pink
let s:purple    = g:miami#palette.purple
let s:red       = g:miami#palette.red
let s:yellow    = g:miami#palette.yellow

let s:none      = ['NONE', 'NONE']

if has('nvim')
  for s:i in range(16)
    let g:terminal_color_{s:i} = g:miami#palette['color_' . s:i]
  endfor
endif

if has('terminal')
  let g:terminal_ansi_colors = []
  for s:i in range(16)
    call add(g:terminal_ansi_colors, g:miami#palette['color_' . s:i])
  endfor
endif

" }}}2
" User Configuration: {{{2

if !exists('g:miami_bold')
  let g:miami_bold = 1
endif

if !exists('g:miami_italic')
  let g:miami_italic = 1
endif

if !exists('g:miami_strikethrough')
  let g:miami_strikethrough = 1
endif

if !exists('g:miami_underline')
  let g:miami_underline = 1
endif

if !exists('g:miami_undercurl')
  let g:miami_undercurl = g:miami_underline
endif

if !exists('g:miami_full_special_attrs_support')
  let g:miami_full_special_attrs_support = has('gui_running')
endif

if !exists('g:miami_inverse')
  let g:miami_inverse = 1
endif

if !exists('g:miami_colorterm')
  let g:miami_colorterm = 1
endif

if !exists('g:miami_high_contrast_diff')
  let g:miami_high_contrast_diff = 0
endif

"}}}2
" Script Helpers: {{{2

let s:attrs = {
      \ 'bold': g:miami_bold == 1 ? 'bold' : 0,
      \ 'italic': g:miami_italic == 1 ? 'italic' : 0,
      \ 'strikethrough': g:miami_strikethrough == 1 ? 'strikethrough' : 0,
      \ 'underline': g:miami_underline == 1 ? 'underline' : 0,
      \ 'undercurl': g:miami_undercurl == 1 ? 'undercurl' : 0,
      \ 'inverse': g:miami_inverse == 1 ? 'inverse' : 0,
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
  " the global variable `g:miami_full_special_attrs_support` explicitly if the
  " default behavior is not desirable.
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !g:miami_full_special_attrs_support
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
" Miami Highlight Groups: {{{2

call s:h('MiamiBgLight', s:none, s:bglight)
call s:h('MiamiBgLighter', s:none, s:bglighter)
call s:h('MiamiBgDark', s:none, s:bgdark)
call s:h('MiamiBgDarker', s:none, s:bgdarker)

call s:h('MiamiFg', s:fg)
call s:h('MiamiFgUnderline', s:fg, s:none, [s:attrs.underline])
call s:h('MiamiFgBold', s:fg, s:none, [s:attrs.bold])
call s:h('MiamiFgStrikethrough', s:fg, s:none, [s:attrs.strikethrough])

call s:h('MiamiComment', s:comment)
call s:h('MiamiCommentBold', s:comment, s:none, [s:attrs.bold])

call s:h('MiamiSelection', s:none, s:selection)

call s:h('MiamiSubtle', s:subtle)

call s:h('MiamiCyan', s:cyan)
call s:h('MiamiCyanItalic', s:cyan, s:none, [s:attrs.italic])

call s:h('MiamiGreen', s:green)
call s:h('MiamiGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('MiamiGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('MiamiGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])

call s:h('MiamiOrange', s:orange)
call s:h('MiamiOrangeBold', s:orange, s:none, [s:attrs.bold])
call s:h('MiamiOrangeItalic', s:orange, s:none, [s:attrs.italic])
call s:h('MiamiOrangeBoldItalic', s:orange, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('MiamiOrangeInverse', s:bg, s:orange)

call s:h('MiamiPink', s:pink)
call s:h('MiamiPinkItalic', s:pink, s:none, [s:attrs.italic])

call s:h('MiamiPurple', s:purple)
call s:h('MiamiPurpleBold', s:purple, s:none, [s:attrs.bold])
call s:h('MiamiPurpleItalic', s:purple, s:none, [s:attrs.italic])

call s:h('MiamiRed', s:red)
call s:h('MiamiRedInverse', s:fg, s:red)

call s:h('MiamiYellow', s:yellow)
call s:h('MiamiYellowItalic', s:yellow, s:none, [s:attrs.italic])

call s:h('MiamiError', s:red, s:none, [], s:red)

call s:h('MiamiErrorLine', s:none, s:none, [s:attrs.undercurl], s:red)
call s:h('MiamiWarnLine', s:none, s:none, [s:attrs.undercurl], s:orange)
call s:h('MiamiInfoLine', s:none, s:none, [s:attrs.undercurl], s:cyan)

call s:h('MiamiTodo', s:cyan, s:none, [s:attrs.bold, s:attrs.inverse])
call s:h('MiamiSearch', s:green, s:none, [s:attrs.inverse])
call s:h('MiamiBoundary', s:comment, s:bgdark)
call s:h('MiamiWinSeparator', s:comment, s:bgdark)
call s:h('MiamiLink', s:cyan, s:none, [s:attrs.underline])

if g:miami_high_contrast_diff
  call s:h('MiamiDiffChange', s:yellow, s:purple)
  call s:h('MiamiDiffDelete', s:bgdark, s:red)
else
  call s:h('MiamiDiffChange', s:orange, s:none)
  call s:h('MiamiDiffDelete', s:red, s:bgdark)
endif

call s:h('MiamiDiffText', s:bg, s:orange)
call s:h('MiamiInlayHint', s:comment, s:bgdark)

" }}}2

" }}}
" User Interface: {{{

set background=dark

" Required as some plugins will overwrite
call s:h('Normal', s:fg, g:miami_colorterm || has('gui_running') ? s:bg : s:none )
call s:h('StatusLine', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineNC', s:none, s:bglight)
call s:h('StatusLineTerm', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineTermNC', s:none, s:bglight)
call s:h('WildMenu', s:bg, s:purple, [s:attrs.bold])
call s:h('CursorLine', s:none, s:subtle)

hi! link ColorColumn  MiamiBgDark
hi! link CursorColumn CursorLine
hi! link CursorLineNr MiamiYellow
hi! link DiffAdd      MiamiGreen
hi! link DiffAdded    DiffAdd
hi! link DiffChange   MiamiDiffChange
hi! link DiffDelete   MiamiDiffDelete
hi! link DiffRemoved  DiffDelete
hi! link DiffText     MiamiDiffText
hi! link Directory    MiamiPurpleBold
hi! link ErrorMsg     MiamiRedInverse
hi! link FoldColumn   MiamiSubtle
hi! link Folded       MiamiBoundary
hi! link IncSearch    MiamiOrangeInverse
call s:h('LineNr', s:comment)
hi! link MoreMsg      MiamiFgBold
hi! link NonText      MiamiSubtle
hi! link Pmenu        MiamiBgDark
hi! link PmenuSbar    MiamiBgDark
hi! link PmenuSel     MiamiSelection
hi! link PmenuThumb   MiamiSelection
call s:h('PmenuMatch', s:cyan, s:bgdark)
call s:h('PmenuMatchSel', s:cyan, s:selection)
hi! link Question     MiamiFgBold
hi! link Search       MiamiSearch
call s:h('SignColumn', s:comment)
hi! link TabLine      MiamiBoundary
hi! link TabLineFill  MiamiBgDark
hi! link TabLineSel   Normal
hi! link Title        MiamiGreenBold
hi! link VertSplit    MiamiWinSeparator
hi! link Visual       MiamiSelection
hi! link VisualNOS    Visual
hi! link WarningMsg   MiamiOrangeInverse

" }}}
" Syntax: {{{

" Required as some plugins will overwrite
call s:h('MatchParen', s:green, s:none, [s:attrs.underline])
call s:h('Conceal', s:cyan, s:none)

" Neovim uses SpecialKey for escape characters only. Vim uses it for that, plus whitespace.
if has('nvim')
  hi! link SpecialKey MiamiRed
  hi! link LspReferenceText MiamiSelection
  hi! link LspReferenceRead MiamiSelection
  hi! link LspReferenceWrite MiamiSelection
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
  hi! link LspInlayHint MiamiInlayHint

  hi! link DiagnosticInfo MiamiCyan
  hi! link DiagnosticHint MiamiCyan
  hi! link DiagnosticError MiamiError
  hi! link DiagnosticWarn MiamiOrange
  hi! link DiagnosticUnderlineError MiamiErrorLine
  hi! link DiagnosticUnderlineHint MiamiInfoLine
  hi! link DiagnosticUnderlineInfo MiamiInfoLine
  hi! link DiagnosticUnderlineWarn MiamiWarnLine

  hi! link WinSeparator MiamiWinSeparator
  hi! link NormalFloat Pmenu

  if has('nvim-0.9')
    hi! link  @lsp.type.class MiamiCyan
    hi! link  @lsp.type.decorator MiamiGreen
    hi! link  @lsp.type.enum MiamiCyan
    hi! link  @lsp.type.enumMember MiamiPurple
    hi! link  @lsp.type.function MiamiGreen
    hi! link  @lsp.type.interface MiamiCyan
    hi! link  @lsp.type.macro MiamiCyan
    hi! link  @lsp.type.method MiamiGreen
    hi! link  @lsp.type.namespace MiamiCyan
    hi! link  @lsp.type.parameter MiamiOrangeItalic
    hi! link  @lsp.type.property MiamiOrange
    hi! link  @lsp.type.struct MiamiCyan
    hi! link  @lsp.type.type MiamiCyanItalic
    hi! link  @lsp.type.typeParameter MiamiPink
    hi! link  @lsp.type.variable MiamiFg
  endif
else
  hi! link SpecialKey MiamiPink
endif

hi! link Comment MiamiComment
hi! link Underlined MiamiFgUnderline
hi! link Todo MiamiTodo

hi! link Error MiamiError
hi! link SpellBad MiamiErrorLine
hi! link SpellLocal MiamiWarnLine
hi! link SpellCap MiamiInfoLine
hi! link SpellRare MiamiInfoLine

hi! link Constant MiamiPurple
hi! link String MiamiYellow
hi! link Character MiamiPink
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Constant

hi! link Identifier MiamiFg
hi! link Function MiamiGreen

hi! link Statement MiamiPink
hi! link Conditional MiamiPink
hi! link Repeat MiamiPink
hi! link Label MiamiPink
hi! link Operator MiamiPink
hi! link Keyword MiamiPink
hi! link Exception MiamiPink

hi! link PreProc MiamiPink
hi! link Include MiamiPink
hi! link Define MiamiPink
hi! link Macro MiamiPink
hi! link PreCondit MiamiPink
hi! link StorageClass MiamiPink
hi! link Structure MiamiPink
hi! link Typedef MiamiPink

hi! link Type MiamiCyanItalic

hi! link Delimiter MiamiFg

hi! link Special MiamiPink
hi! link SpecialComment MiamiCyanItalic
hi! link Tag MiamiCyan
hi! link helpHyperTextJump MiamiLink
hi! link helpCommand MiamiPurple
hi! link helpExample MiamiGreen
hi! link helpBacktick Special

" }}}

" Languages: {{{

" CSS: {{{
hi! link cssAttrComma         Delimiter
hi! link cssAttrRegion        MiamiPink
hi! link cssAttributeSelector MiamiGreenItalic
hi! link cssBraces            Delimiter
hi! link cssFunctionComma     Delimiter
hi! link cssNoise             MiamiPink
hi! link cssProp              MiamiCyan
hi! link cssPseudoClass       MiamiPink
hi! link cssPseudoClassId     MiamiGreenItalic
hi! link cssUnitDecorators    MiamiPink
hi! link cssVendor            MiamiGreenItalic
" }}}

" Git Commit: {{{
" The following two are misnomers. Colors are correct.
hi! link diffFile    MiamiGreen
hi! link diffNewFile MiamiRed

hi! link diffAdded   MiamiGreen
hi! link diffLine    MiamiCyanItalic
hi! link diffRemoved MiamiRed
" }}}

" HTML: {{{
hi! link htmlTag         MiamiFg
hi! link htmlArg         MiamiGreenItalic
hi! link htmlTitle       MiamiFg
hi! link htmlH1          MiamiFg
hi! link htmlSpecialChar MiamiPurple
" }}}

" JavaScript: {{{
hi! link javaScriptBraces   Delimiter
hi! link javaScriptNumber   Constant
hi! link javaScriptNull     Constant
hi! link javaScriptFunction Keyword

" pangloss/vim-javascript
hi! link jsArrowFunction           Operator
hi! link jsBuiltins                MiamiCyan
hi! link jsClassDefinition         MiamiCyan
hi! link jsClassMethodType         Keyword
hi! link jsDestructuringAssignment MiamiOrangeItalic
hi! link jsDocParam                MiamiOrangeItalic
hi! link jsDocTags                 Keyword
hi! link jsDocType                 Type
hi! link jsDocTypeBrackets         MiamiCyan
hi! link jsFuncArgOperator         Operator
hi! link jsFuncArgs                MiamiOrangeItalic
hi! link jsFunction                Keyword
hi! link jsNull                    Constant
hi! link jsObjectColon             MiamiPink
hi! link jsSuper                   MiamiPurpleItalic
hi! link jsTemplateBraces          Special
hi! link jsThis                    MiamiPurpleItalic
hi! link jsUndefined               Constant

" maxmellon/vim-jsx-pretty
hi! link jsxTag             Keyword
hi! link jsxTagName         Keyword
hi! link jsxComponentName   Type
hi! link jsxCloseTag        Type
hi! link jsxAttrib          MiamiGreenItalic
hi! link jsxCloseString     Identifier
hi! link jsxOpenPunct       Identifier
" }}}

" JSON: {{{
hi! link jsonKeyword      MiamiCyan
hi! link jsonKeywordMatch MiamiPink
" }}}

" Lua: {{{
hi! link luaFunc  MiamiCyan
hi! link luaTable MiamiFg

" tbastos/vim-lua
hi! link luaBraces       MiamiFg
hi! link luaBuiltIn      Constant
hi! link luaDocTag       Keyword
hi! link luaErrHand      MiamiCyan
hi! link luaFuncArgName  MiamiOrangeItalic
hi! link luaFuncCall     Function
hi! link luaLocal        Keyword
hi! link luaSpecialTable Constant
hi! link luaSpecialValue MiamiCyan
" }}}

" Markdown: {{{
hi! link markdownBlockquote        MiamiCyan
hi! link markdownBold              MiamiOrangeBold
hi! link markdownBoldItalic        MiamiOrangeBoldItalic
hi! link markdownCodeBlock         MiamiGreen
hi! link markdownCode              MiamiGreen
hi! link markdownCodeDelimiter     MiamiGreen
hi! link markdownH1                MiamiPurpleBold
hi! link markdownH2                markdownH1
hi! link markdownH3                markdownH1
hi! link markdownH4                markdownH1
hi! link markdownH5                markdownH1
hi! link markdownH6                markdownH1
hi! link markdownHeadingDelimiter  markdownH1
hi! link markdownHeadingRule       markdownH1
hi! link markdownItalic            MiamiYellowItalic
hi! link markdownLinkText          MiamiPink
hi! link markdownListMarker        MiamiCyan
hi! link markdownOrderedListMarker MiamiCyan
hi! link markdownRule              MiamiComment
hi! link markdownUrl               MiamiLink

" plasticboy/vim-markdown
hi! link htmlBold       MiamiOrangeBold
hi! link htmlBoldItalic MiamiOrangeBoldItalic
hi! link htmlH1         MiamiPurpleBold
hi! link htmlItalic     MiamiYellowItalic
hi! link mkdBlockquote  MiamiYellowItalic
hi! link mkdBold        MiamiOrangeBold
hi! link mkdBoldItalic  MiamiOrangeBoldItalic
hi! link mkdCode        MiamiGreen
hi! link mkdCodeEnd     MiamiGreen
hi! link mkdCodeStart   MiamiGreen
hi! link mkdHeading     MiamiPurpleBold
hi! link mkdInlineUrl   MiamiLink
hi! link mkdItalic      MiamiYellowItalic
hi! link mkdLink        MiamiPink
hi! link mkdListItem    MiamiCyan
hi! link mkdRule        MiamiComment
hi! link mkdUrl         MiamiLink
" }}}

" OCaml: {{{
hi! link ocamlModule  Type
hi! link ocamlModPath Normal
hi! link ocamlLabel   MiamiOrangeItalic
" }}}

" Perl: {{{
" Regex
hi! link perlMatchStartEnd       MiamiRed

" Builtin functions
hi! link perlOperator            MiamiCyan
hi! link perlStatementFiledesc   MiamiCyan
hi! link perlStatementFiles      MiamiCyan
hi! link perlStatementFlow       MiamiCyan
hi! link perlStatementHash       MiamiCyan
hi! link perlStatementIOfunc     MiamiCyan
hi! link perlStatementIPC        MiamiCyan
hi! link perlStatementList       MiamiCyan
hi! link perlStatementMisc       MiamiCyan
hi! link perlStatementNetwork    MiamiCyan
hi! link perlStatementNumeric    MiamiCyan
hi! link perlStatementProc       MiamiCyan
hi! link perlStatementPword      MiamiCyan
hi! link perlStatementRegexp     MiamiCyan
hi! link perlStatementScalar     MiamiCyan
hi! link perlStatementSocket     MiamiCyan
hi! link perlStatementTime       MiamiCyan
hi! link perlStatementVector     MiamiCyan

" Highlighting for quoting constructs, tied to existing option in vim-perl
if get(g:, 'perl_string_as_statement', 0)
  hi! link perlStringStartEnd MiamiRed
endif

" Signatures
hi! link perlSignature           MiamiOrangeItalic
hi! link perlSubPrototype        MiamiOrangeItalic

" Hash keys
hi! link perlVarSimpleMemberName MiamiPurple
" }}}

" PHP: {{{
hi! link phpClass           Type
hi! link phpClasses         Type
hi! link phpDocTags         MiamiCyanItalic
hi! link phpFunction        Function
hi! link phpParent          Normal
hi! link phpSpecialFunction MiamiCyan
" }}}

" PlantUML: {{{
hi! link plantumlClassPrivate              SpecialKey
hi! link plantumlClassProtected            MiamiOrange
hi! link plantumlClassPublic               Function
hi! link plantumlColonLine                 String
hi! link plantumlDirectedOrVerticalArrowLR Constant
hi! link plantumlDirectedOrVerticalArrowRL Constant
hi! link plantumlHorizontalArrow           Constant
hi! link plantumlSkinParamKeyword          MiamiCyan
hi! link plantumlTypeKeyword               Keyword
" }}}

" PureScript: {{{
hi! link purescriptModule Type
hi! link purescriptImport MiamiCyan
hi! link purescriptImportAs MiamiCyan
hi! link purescriptOperator Operator
hi! link purescriptBacktick Operator
" }}}

" Python: {{{
hi! link pythonBuiltinObj    Type
hi! link pythonBuiltinObject Type
hi! link pythonBuiltinType   Type
hi! link pythonClassVar      MiamiPurpleItalic
hi! link pythonExClass       Type
hi! link pythonNone          Type
hi! link pythonRun           Comment
" }}}

" reStructuredText: {{{
hi! link rstComment                             Comment
hi! link rstTransition                          Comment
hi! link rstCodeBlock                           MiamiGreen
hi! link rstInlineLiteral                       MiamiGreen
hi! link rstLiteralBlock                        MiamiGreen
hi! link rstQuotedLiteralBlock                  MiamiGreen
hi! link rstStandaloneHyperlink                 MiamiLink
hi! link rstStrongEmphasis                      MiamiOrangeBold
hi! link rstSections                            MiamiPurpleBold
hi! link rstEmphasis                            MiamiYellowItalic
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

hi! link rubyBlockArgument          MiamiOrangeItalic
hi! link rubyBlockParameter         MiamiOrangeItalic
hi! link rubyCurlyBlock             MiamiPink
hi! link rubyGlobalVariable         MiamiPurple
hi! link rubyInstanceVariable       MiamiPurpleItalic
hi! link rubyInterpolationDelimiter MiamiPink
hi! link rubyRegexpDelimiter        MiamiRed
hi! link rubyStringDelimiter        MiamiYellow
" }}}

" Rust: {{{
hi! link rustCommentLineDoc Comment
" }}}

" Sass: {{{
hi! link sassClass                  cssClassName
hi! link sassClassChar              cssClassNameDot
hi! link sassId                     cssIdentifier
hi! link sassIdChar                 cssIdentifier
hi! link sassInterpolationDelimiter MiamiPink
hi! link sassMixinName              Function
hi! link sassProperty               cssProp
hi! link sassVariableAssignment     Operator
" }}}

" Shell: {{{
hi! link shCommandSub NONE
hi! link shEscape     MiamiRed
hi! link shParen      NONE
hi! link shParenError NONE
" }}}

" Tex: {{{
hi! link texBeginEndName  MiamiOrangeItalic
hi! link texBoldItalStyle MiamiOrangeBoldItalic
hi! link texBoldStyle     MiamiOrangeBold
hi! link texInputFile     MiamiOrangeItalic
hi! link texItalStyle     MiamiYellowItalic
hi! link texLigature      MiamiPurple
hi! link texMath          MiamiPurple
hi! link texMathMatcher   MiamiPurple
hi! link texMathSymbol    MiamiPurple
hi! link texSpecialChar   MiamiPurple
hi! link texSubscripts    MiamiPurple
hi! link texTitle         MiamiFgBold
" }}}

" Typescript: {{{
hi! link typescriptAliasDeclaration       Type
hi! link typescriptArrayMethod            Function
hi! link typescriptArrowFunc              Operator
hi! link typescriptArrowFuncArg           MiamiOrangeItalic
hi! link typescriptAssign                 Operator
hi! link typescriptBOMWindowProp          Constant
hi! link typescriptBinaryOp               Operator
hi! link typescriptBraces                 Delimiter
hi! link typescriptCall                   typescriptArrowFuncArg
hi! link typescriptClassHeritage          Type
hi! link typescriptClassName              Type
hi! link typescriptDateMethod             MiamiCyan
hi! link typescriptDateStaticMethod       Function
hi! link typescriptDecorator              MiamiGreenItalic
hi! link typescriptDefaultParam           Operator
hi! link typescriptES6SetMethod           MiamiCyan
hi! link typescriptEndColons              Delimiter
hi! link typescriptEnum                   Type
hi! link typescriptEnumKeyword            Keyword
hi! link typescriptFuncComma              Delimiter
hi! link typescriptFuncKeyword            Keyword
hi! link typescriptFuncType               MiamiOrangeItalic
hi! link typescriptFuncTypeArrow          Operator
hi! link typescriptGlobal                 Type
hi! link typescriptGlobalMethod           MiamiCyan
hi! link typescriptGlobalObjects          Type
hi! link typescriptIdentifier             MiamiPurpleItalic
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
hi! link typescriptParamImpl              MiamiOrangeItalic
hi! link typescriptParens                 Delimiter
hi! link typescriptPredefinedType         Type
hi! link typescriptRestOrSpread           Operator
hi! link typescriptTernaryOp              Operator
hi! link typescriptTypeAnnotation         Special
hi! link typescriptTypeCast               Operator
hi! link typescriptTypeParameter          MiamiOrangeItalic
hi! link typescriptTypeReference          Type
hi! link typescriptUnaryOp                Operator
hi! link typescriptVariable               Keyword

hi! link tsxAttrib           MiamiGreenItalic
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
hi! link xmlAttrib  MiamiGreenItalic
hi! link xmlEqual   Operator
hi! link xmlTag     Delimiter
hi! link xmlTagName Statement

" Fixes missing highlight over end tags
syn region xmlTagName
	\ matchgroup=xmlTag start=+</[^ /!?<>"']\@=+
	\ matchgroup=xmlTag end=+>+
" }}}

" YAML: {{{
hi! link yamlAlias           MiamiGreenItalicUnderline
hi! link yamlAnchor          MiamiPinkItalic
hi! link yamlBlockMappingKey MiamiCyan
hi! link yamlFlowCollection  MiamiPink
hi! link yamlFlowIndicator   Delimiter
hi! link yamlNodeTag         MiamiPink
hi! link yamlPlainScalar     MiamiYellow
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
    \ 'hl+':     ['fg', 'MiamiOrange'],
    \ 'info':    ['fg', 'MiamiPurple'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'MiamiGreen'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'],
    \}
endif
" }}}

" dense-analysis/ale {{{
hi! link ALEError              MiamiErrorLine
hi! link ALEWarning            MiamiWarnLine
hi! link ALEInfo               MiamiInfoLine

hi! link ALEErrorSign          MiamiRed
hi! link ALEWarningSign        MiamiOrange
hi! link ALEInfoSign           MiamiCyan

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
  " those highlight groups when the defaults do not match the miami
  " specification.
  " https://github.com/nvim-treesitter/nvim-treesitter/blob/master/plugin/nvim-treesitter.vim

  " deprecated TS* highlight groups
  " see https://github.com/nvim-treesitter/nvim-treesitter/pull/3656
  " # Misc
  hi! link TSPunctSpecial Special
  " # Constants
  hi! link TSConstMacro Macro
  hi! link TSStringEscape Character
  hi! link TSSymbol MiamiPurple
  hi! link TSAnnotation MiamiYellow
  hi! link TSAttribute MiamiGreenItalic
  " # Functions
  hi! link TSFuncBuiltin MiamiCyan
  hi! link TSFuncMacro Function
  hi! link TSParameter MiamiOrangeItalic
  hi! link TSParameterReference MiamiOrange
  hi! link TSField MiamiOrange
  hi! link TSConstructor MiamiCyan
  " # Keywords
  hi! link TSLabel MiamiPurpleItalic
  " # Variable
  hi! link TSVariableBuiltin MiamiPurpleItalic
  " # Text
  hi! link TSStrong MiamiFgBold
  hi! link TSEmphasis MiamiFg
  hi! link TSUnderline Underlined
  hi! link TSTitle MiamiYellow
  hi! link TSLiteral MiamiYellow
  hi! link TSURI MiamiYellow
  " HTML and JSX tag attributes. By default, this group is linked to TSProperty,
  " which in turn links to Identifer (white).
  hi! link TSTagAttribute MiamiGreenItalic

  if has('nvim-0.8.1')
    " # Misc
    hi! link @punctuation.delimiter Delimiter
    hi! link @punctuation.bracket MiamiFg
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
    hi! link @string.special.symbol MiamiPurple
    hi! link @string.special.url Underlined
    hi! link @symbol MiamiPurple
    hi! link @annotation MiamiYellow
    hi! link @attribute MiamiGreenItalic
    hi! link @namespace Structure
    hi! link @module Structure
    hi! link @module.builtin Special
    " # Functions
    hi! link @function.builtin MiamiCyan
    hi! link @funcion.macro Function
    hi! link @function Function
    hi! link @parameter MiamiOrangeItalic
    hi! link @parameter.reference MiamiOrange
    hi! link @field MiamiOrange
    hi! link @property MiamiFg
    hi! link @constructor MiamiCyan
    " # Keywords
    hi! link @label MiamiPurpleItalic
    hi! link @keyword.function MiamiPink
    hi! link @keyword.operator Operator
    hi! link @keyword Keyword
    hi! link @exception MiamiPurple
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
    hi! link @variable MiamiFg
    hi! link @variable.builtin MiamiPurpleItalic
    hi! link @variable.parameter MiamiOrangeItalic
    hi! link @variable.member  MiamiOrange
    " # Text
    hi! link @text MiamiFg
    hi! link @text.strong MiamiFgBold
    hi! link @text.emphasis MiamiFg
    hi! link @text.underline Underlined
    hi! link @text.title MiamiYellow
    hi! link @text.literal MiamiYellow
    hi! link @text.uri MiamiYellow
    hi! link @text.diff.add DiffAdd
    hi! link @text.diff.delete DiffDelete

    hi! link @markup.strong MiamiFgBold
    hi! link @markup.italic MiamiFgItalic
    hi! link @markup.strikethrough MiamiFgStrikethrough
    hi! link @markup.underline Underlined

    hi! link @markup Special
    hi! link @markup.heading MiamiYellow
    hi! link @markup.link Underlined
    hi! link @markup.link.uri MiamiYellow
    hi! link @markup.link.label SpecialChar
    hi! link @markup.raw MiamiYellow
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
    hi! link @tag MiamiCyan
    hi! link @tag.delimiter MiamiFg
    " HTML and JSX tag attributes. By default, this group is linked to TSProperty,
    " which in turn links to Identifer (white).
    hi! link @tag.attribute MiamiGreenItalic
  endif
  " }}}

  " hrsh7th/nvim-cmp {{{
  hi! link CmpItemAbbrDeprecated MiamiError

  hi! link CmpItemAbbrMatch MiamiCyan
  hi! link CmpItemAbbrMatchFuzzy MiamiCyan

  hi! link CmpItemKindText MiamiFg
  hi! link CmpItemKindMethod Function
  hi! link CmpItemKindFunction Function
  hi! link CmpItemKindConstructor MiamiCyan
  hi! link CmpItemKindField MiamiOrange
  hi! link CmpItemKindVariable MiamiPurpleItalic
  hi! link CmpItemKindClass MiamiCyan
  hi! link CmpItemKindInterface MiamiCyan
  hi! link CmpItemKindModule MiamiYellow
  hi! link CmpItemKindProperty MiamiPink
  hi! link CmpItemKindUnit MiamiFg
  hi! link CmpItemKindValue MiamiYellow
  hi! link CmpItemKindEnum MiamiPink
  hi! link CmpItemKindKeyword MiamiPink
  hi! link CmpItemKindSnippet MiamiFg
  hi! link CmpItemKindColor MiamiYellow
  hi! link CmpItemKindFile MiamiYellow
  hi! link CmpItemKindReference MiamiOrange
  hi! link CmpItemKindFolder MiamiYellow
  hi! link CmpItemKindEnumMember MiamiPurple
  hi! link CmpItemKindConstant MiamiPurple
  hi! link CmpItemKindStruct MiamiPink
  hi! link CmpItemKindEvent MiamiFg
  hi! link CmpItemKindOperator MiamiPink
  hi! link CmpItemKindTypeParameter MiamiCyan

  hi! link CmpItemMenu Comment
  " }}}

  " lewis6991/gitsigns.nvim {{{
  hi! link GitSignsAdd      DiffAdd
  hi! link GitSignsAddLn    DiffAdd
  hi! link GitSignsAddNr    DiffAdd
  hi! link GitSignsChange   DiffChange
  hi! link GitSignsChangeLn DiffChange
  hi! link GitSignsChangeNr DiffChange

  hi! link GitSignsDelete   MiamiRed
  hi! link GitSignsDeleteLn MiamiRed
  hi! link GitSignsDeleteNr MiamiRed
  " }}}

endif
" }}}

" }}}

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0 et:
