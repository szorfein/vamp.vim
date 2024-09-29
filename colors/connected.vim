" Connected Theme: {{{
"
" https://github.com/zenorocha/connected-theme
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

let g:colors_name = 'connected'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" Palette: {{{2

let s:fg        = g:connected#palette.fg

let s:bglighter = g:connected#palette.bglighter
let s:bglight   = g:connected#palette.bglight
let s:bg        = g:connected#palette.bg
let s:bgdark    = g:connected#palette.bgdark
let s:bgdarker  = g:connected#palette.bgdarker

let s:comment   = g:connected#palette.comment
let s:selection = g:connected#palette.selection
let s:subtle    = g:connected#palette.subtle

let s:cyan      = g:connected#palette.cyan
let s:green     = g:connected#palette.green
let s:orange    = g:connected#palette.orange
let s:pink      = g:connected#palette.pink
let s:purple    = g:connected#palette.purple
let s:red       = g:connected#palette.red
let s:yellow    = g:connected#palette.yellow

let s:none      = ['NONE', 'NONE']

if has('nvim')
  for s:i in range(16)
    let g:terminal_color_{s:i} = g:connected#palette['color_' . s:i]
  endfor
endif

if has('terminal')
  let g:terminal_ansi_colors = []
  for s:i in range(16)
    call add(g:terminal_ansi_colors, g:connected#palette['color_' . s:i])
  endfor
endif

" }}}2
" User Configuration: {{{2

if !exists('g:connected_bold')
  let g:connected_bold = 1
endif

if !exists('g:connected_italic')
  let g:connected_italic = 1
endif

if !exists('g:connected_strikethrough')
  let g:connected_strikethrough = 1
endif

if !exists('g:connected_underline')
  let g:connected_underline = 1
endif

if !exists('g:connected_undercurl')
  let g:connected_undercurl = g:connected_underline
endif

if !exists('g:connected_full_special_attrs_support')
  let g:connected_full_special_attrs_support = has('gui_running')
endif

if !exists('g:connected_inverse')
  let g:connected_inverse = 1
endif

if !exists('g:connected_colorterm')
  let g:connected_colorterm = 1
endif

if !exists('g:connected_high_contrast_diff')
  let g:connected_high_contrast_diff = 0
endif

"}}}2
" Script Helpers: {{{2

let s:attrs = {
      \ 'bold': g:connected_bold == 1 ? 'bold' : 0,
      \ 'italic': g:connected_italic == 1 ? 'italic' : 0,
      \ 'strikethrough': g:connected_strikethrough == 1 ? 'strikethrough' : 0,
      \ 'underline': g:connected_underline == 1 ? 'underline' : 0,
      \ 'undercurl': g:connected_undercurl == 1 ? 'undercurl' : 0,
      \ 'inverse': g:connected_inverse == 1 ? 'inverse' : 0,
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
  " the global variable `g:connected_full_special_attrs_support` explicitly if the
  " default behavior is not desirable.
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !g:connected_full_special_attrs_support
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
" Connected Highlight Groups: {{{2

call s:h('ConnectedBgLight', s:none, s:bglight)
call s:h('ConnectedBgLighter', s:none, s:bglighter)
call s:h('ConnectedBgDark', s:none, s:bgdark)
call s:h('ConnectedBgDarker', s:none, s:bgdarker)

call s:h('ConnectedFg', s:fg)
call s:h('ConnectedFgUnderline', s:fg, s:none, [s:attrs.underline])
call s:h('ConnectedFgBold', s:fg, s:none, [s:attrs.bold])
call s:h('ConnectedFgStrikethrough', s:fg, s:none, [s:attrs.strikethrough])

call s:h('ConnectedComment', s:comment)
call s:h('ConnectedCommentBold', s:comment, s:none, [s:attrs.bold])

call s:h('ConnectedSelection', s:none, s:selection)

call s:h('ConnectedSubtle', s:subtle)

call s:h('ConnectedCyan', s:cyan)
call s:h('ConnectedCyanItalic', s:cyan, s:none, [s:attrs.italic])

call s:h('ConnectedGreen', s:green)
call s:h('ConnectedGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('ConnectedGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('ConnectedGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])

call s:h('ConnectedOrange', s:orange)
call s:h('ConnectedOrangeBold', s:orange, s:none, [s:attrs.bold])
call s:h('ConnectedOrangeItalic', s:orange, s:none, [s:attrs.italic])
call s:h('ConnectedOrangeBoldItalic', s:orange, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('ConnectedOrangeInverse', s:bg, s:orange)

call s:h('ConnectedPink', s:pink)
call s:h('ConnectedPinkItalic', s:pink, s:none, [s:attrs.italic])

call s:h('ConnectedPurple', s:purple)
call s:h('ConnectedPurpleBold', s:purple, s:none, [s:attrs.bold])
call s:h('ConnectedPurpleItalic', s:purple, s:none, [s:attrs.italic])

call s:h('ConnectedRed', s:red)
call s:h('ConnectedRedInverse', s:fg, s:red)

call s:h('ConnectedYellow', s:yellow)
call s:h('ConnectedYellowItalic', s:yellow, s:none, [s:attrs.italic])

call s:h('ConnectedError', s:red, s:none, [], s:red)

call s:h('ConnectedErrorLine', s:none, s:none, [s:attrs.undercurl], s:red)
call s:h('ConnectedWarnLine', s:none, s:none, [s:attrs.undercurl], s:orange)
call s:h('ConnectedInfoLine', s:none, s:none, [s:attrs.undercurl], s:cyan)

call s:h('ConnectedTodo', s:cyan, s:none, [s:attrs.bold, s:attrs.inverse])
call s:h('ConnectedSearch', s:green, s:none, [s:attrs.inverse])
call s:h('ConnectedBoundary', s:comment, s:bgdark)
call s:h('ConnectedWinSeparator', s:comment, s:bgdark)
call s:h('ConnectedLink', s:cyan, s:none, [s:attrs.underline])

if g:connected_high_contrast_diff
  call s:h('ConnectedDiffChange', s:yellow, s:purple)
  call s:h('ConnectedDiffDelete', s:bgdark, s:red)
else
  call s:h('ConnectedDiffChange', s:orange, s:none)
  call s:h('ConnectedDiffDelete', s:red, s:bgdark)
endif

call s:h('ConnectedDiffText', s:bg, s:orange)
call s:h('ConnectedInlayHint', s:comment, s:bgdark)

" }}}2

" }}}
" User Interface: {{{

set background=dark

" Required as some plugins will overwrite
call s:h('Normal', s:fg, g:connected_colorterm || has('gui_running') ? s:bg : s:none )
call s:h('StatusLine', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineNC', s:none, s:bglight)
call s:h('StatusLineTerm', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineTermNC', s:none, s:bglight)
call s:h('WildMenu', s:bg, s:purple, [s:attrs.bold])
call s:h('CursorLine', s:none, s:subtle)

hi! link ColorColumn  ConnectedBgDark
hi! link CursorColumn CursorLine
hi! link CursorLineNr ConnectedYellow
hi! link DiffAdd      ConnectedGreen
hi! link DiffAdded    DiffAdd
hi! link DiffChange   ConnectedDiffChange
hi! link DiffDelete   ConnectedDiffDelete
hi! link DiffRemoved  DiffDelete
hi! link DiffText     ConnectedDiffText
hi! link Directory    ConnectedPurpleBold
hi! link ErrorMsg     ConnectedRedInverse
hi! link FoldColumn   ConnectedSubtle
hi! link Folded       ConnectedBoundary
hi! link IncSearch    ConnectedOrangeInverse
call s:h('LineNr', s:comment)
hi! link MoreMsg      ConnectedFgBold
hi! link NonText      ConnectedSubtle
hi! link Pmenu        ConnectedBgDark
hi! link PmenuSbar    ConnectedBgDark
hi! link PmenuSel     ConnectedSelection
hi! link PmenuThumb   ConnectedSelection
call s:h('PmenuMatch', s:cyan, s:bgdark)
call s:h('PmenuMatchSel', s:cyan, s:selection)
hi! link Question     ConnectedFgBold
hi! link Search       ConnectedSearch
call s:h('SignColumn', s:comment)
hi! link TabLine      ConnectedBoundary
hi! link TabLineFill  ConnectedBgDark
hi! link TabLineSel   Normal
hi! link Title        ConnectedGreenBold
hi! link VertSplit    ConnectedWinSeparator
hi! link Visual       ConnectedSelection
hi! link VisualNOS    Visual
hi! link WarningMsg   ConnectedOrangeInverse

" }}}
" Syntax: {{{

" Required as some plugins will overwrite
call s:h('MatchParen', s:green, s:none, [s:attrs.underline])
call s:h('Conceal', s:cyan, s:none)

" Neovim uses SpecialKey for escape characters only. Vim uses it for that, plus whitespace.
if has('nvim')
  hi! link SpecialKey ConnectedRed
  hi! link LspReferenceText ConnectedSelection
  hi! link LspReferenceRead ConnectedSelection
  hi! link LspReferenceWrite ConnectedSelection
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
  hi! link LspInlayHint ConnectedInlayHint

  hi! link DiagnosticInfo ConnectedCyan
  hi! link DiagnosticHint ConnectedCyan
  hi! link DiagnosticError ConnectedError
  hi! link DiagnosticWarn ConnectedOrange
  hi! link DiagnosticUnderlineError ConnectedErrorLine
  hi! link DiagnosticUnderlineHint ConnectedInfoLine
  hi! link DiagnosticUnderlineInfo ConnectedInfoLine
  hi! link DiagnosticUnderlineWarn ConnectedWarnLine

  hi! link WinSeparator ConnectedWinSeparator
  hi! link NormalFloat Pmenu

  if has('nvim-0.9')
    hi! link  @lsp.type.class ConnectedCyan
    hi! link  @lsp.type.decorator ConnectedGreen
    hi! link  @lsp.type.enum ConnectedCyan
    hi! link  @lsp.type.enumMember ConnectedPurple
    hi! link  @lsp.type.function ConnectedGreen
    hi! link  @lsp.type.interface ConnectedCyan
    hi! link  @lsp.type.macro ConnectedCyan
    hi! link  @lsp.type.method ConnectedGreen
    hi! link  @lsp.type.namespace ConnectedCyan
    hi! link  @lsp.type.parameter ConnectedOrangeItalic
    hi! link  @lsp.type.property ConnectedOrange
    hi! link  @lsp.type.struct ConnectedCyan
    hi! link  @lsp.type.type ConnectedCyanItalic
    hi! link  @lsp.type.typeParameter ConnectedPink
    hi! link  @lsp.type.variable ConnectedFg
  endif
else
  hi! link SpecialKey ConnectedPink
endif

hi! link Comment ConnectedComment
hi! link Underlined ConnectedFgUnderline
hi! link Todo ConnectedTodo

hi! link Error ConnectedError
hi! link SpellBad ConnectedErrorLine
hi! link SpellLocal ConnectedWarnLine
hi! link SpellCap ConnectedInfoLine
hi! link SpellRare ConnectedInfoLine

hi! link Constant ConnectedPurple
hi! link String ConnectedYellow
hi! link Character ConnectedPink
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Constant

hi! link Identifier ConnectedFg
hi! link Function ConnectedGreen

hi! link Statement ConnectedPink
hi! link Conditional ConnectedPink
hi! link Repeat ConnectedPink
hi! link Label ConnectedPink
hi! link Operator ConnectedPink
hi! link Keyword ConnectedPink
hi! link Exception ConnectedPink

hi! link PreProc ConnectedPink
hi! link Include ConnectedPink
hi! link Define ConnectedPink
hi! link Macro ConnectedPink
hi! link PreCondit ConnectedPink
hi! link StorageClass ConnectedPink
hi! link Structure ConnectedPink
hi! link Typedef ConnectedPink

hi! link Type ConnectedCyanItalic

hi! link Delimiter ConnectedFg

hi! link Special ConnectedPink
hi! link SpecialComment ConnectedCyanItalic
hi! link Tag ConnectedCyan
hi! link helpHyperTextJump ConnectedLink
hi! link helpCommand ConnectedPurple
hi! link helpExample ConnectedGreen
hi! link helpBacktick Special

" }}}

" Languages: {{{

" CSS: {{{
hi! link cssAttrComma         Delimiter
hi! link cssAttrRegion        ConnectedPink
hi! link cssAttributeSelector ConnectedGreenItalic
hi! link cssBraces            Delimiter
hi! link cssFunctionComma     Delimiter
hi! link cssNoise             ConnectedPink
hi! link cssProp              ConnectedCyan
hi! link cssPseudoClass       ConnectedPink
hi! link cssPseudoClassId     ConnectedGreenItalic
hi! link cssUnitDecorators    ConnectedPink
hi! link cssVendor            ConnectedGreenItalic
" }}}

" Git Commit: {{{
" The following two are misnomers. Colors are correct.
hi! link diffFile    ConnectedGreen
hi! link diffNewFile ConnectedRed

hi! link diffAdded   ConnectedGreen
hi! link diffLine    ConnectedCyanItalic
hi! link diffRemoved ConnectedRed
" }}}

" HTML: {{{
hi! link htmlTag         ConnectedFg
hi! link htmlArg         ConnectedGreenItalic
hi! link htmlTitle       ConnectedFg
hi! link htmlH1          ConnectedFg
hi! link htmlSpecialChar ConnectedPurple
" }}}

" JavaScript: {{{
hi! link javaScriptBraces   Delimiter
hi! link javaScriptNumber   Constant
hi! link javaScriptNull     Constant
hi! link javaScriptFunction Keyword

" pangloss/vim-javascript
hi! link jsArrowFunction           Operator
hi! link jsBuiltins                ConnectedCyan
hi! link jsClassDefinition         ConnectedCyan
hi! link jsClassMethodType         Keyword
hi! link jsDestructuringAssignment ConnectedOrangeItalic
hi! link jsDocParam                ConnectedOrangeItalic
hi! link jsDocTags                 Keyword
hi! link jsDocType                 Type
hi! link jsDocTypeBrackets         ConnectedCyan
hi! link jsFuncArgOperator         Operator
hi! link jsFuncArgs                ConnectedOrangeItalic
hi! link jsFunction                Keyword
hi! link jsNull                    Constant
hi! link jsObjectColon             ConnectedPink
hi! link jsSuper                   ConnectedPurpleItalic
hi! link jsTemplateBraces          Special
hi! link jsThis                    ConnectedPurpleItalic
hi! link jsUndefined               Constant

" maxmellon/vim-jsx-pretty
hi! link jsxTag             Keyword
hi! link jsxTagName         Keyword
hi! link jsxComponentName   Type
hi! link jsxCloseTag        Type
hi! link jsxAttrib          ConnectedGreenItalic
hi! link jsxCloseString     Identifier
hi! link jsxOpenPunct       Identifier
" }}}

" JSON: {{{
hi! link jsonKeyword      ConnectedCyan
hi! link jsonKeywordMatch ConnectedPink
" }}}

" Lua: {{{
hi! link luaFunc  ConnectedCyan
hi! link luaTable ConnectedFg

" tbastos/vim-lua
hi! link luaBraces       ConnectedFg
hi! link luaBuiltIn      Constant
hi! link luaDocTag       Keyword
hi! link luaErrHand      ConnectedCyan
hi! link luaFuncArgName  ConnectedOrangeItalic
hi! link luaFuncCall     Function
hi! link luaLocal        Keyword
hi! link luaSpecialTable Constant
hi! link luaSpecialValue ConnectedCyan
" }}}

" Markdown: {{{
hi! link markdownBlockquote        ConnectedCyan
hi! link markdownBold              ConnectedOrangeBold
hi! link markdownBoldItalic        ConnectedOrangeBoldItalic
hi! link markdownCodeBlock         ConnectedGreen
hi! link markdownCode              ConnectedGreen
hi! link markdownCodeDelimiter     ConnectedGreen
hi! link markdownH1                ConnectedPurpleBold
hi! link markdownH2                markdownH1
hi! link markdownH3                markdownH1
hi! link markdownH4                markdownH1
hi! link markdownH5                markdownH1
hi! link markdownH6                markdownH1
hi! link markdownHeadingDelimiter  markdownH1
hi! link markdownHeadingRule       markdownH1
hi! link markdownItalic            ConnectedYellowItalic
hi! link markdownLinkText          ConnectedPink
hi! link markdownListMarker        ConnectedCyan
hi! link markdownOrderedListMarker ConnectedCyan
hi! link markdownRule              ConnectedComment
hi! link markdownUrl               ConnectedLink

" plasticboy/vim-markdown
hi! link htmlBold       ConnectedOrangeBold
hi! link htmlBoldItalic ConnectedOrangeBoldItalic
hi! link htmlH1         ConnectedPurpleBold
hi! link htmlItalic     ConnectedYellowItalic
hi! link mkdBlockquote  ConnectedYellowItalic
hi! link mkdBold        ConnectedOrangeBold
hi! link mkdBoldItalic  ConnectedOrangeBoldItalic
hi! link mkdCode        ConnectedGreen
hi! link mkdCodeEnd     ConnectedGreen
hi! link mkdCodeStart   ConnectedGreen
hi! link mkdHeading     ConnectedPurpleBold
hi! link mkdInlineUrl   ConnectedLink
hi! link mkdItalic      ConnectedYellowItalic
hi! link mkdLink        ConnectedPink
hi! link mkdListItem    ConnectedCyan
hi! link mkdRule        ConnectedComment
hi! link mkdUrl         ConnectedLink
" }}}

" OCaml: {{{
hi! link ocamlModule  Type
hi! link ocamlModPath Normal
hi! link ocamlLabel   ConnectedOrangeItalic
" }}}

" Perl: {{{
" Regex
hi! link perlMatchStartEnd       ConnectedRed

" Builtin functions
hi! link perlOperator            ConnectedCyan
hi! link perlStatementFiledesc   ConnectedCyan
hi! link perlStatementFiles      ConnectedCyan
hi! link perlStatementFlow       ConnectedCyan
hi! link perlStatementHash       ConnectedCyan
hi! link perlStatementIOfunc     ConnectedCyan
hi! link perlStatementIPC        ConnectedCyan
hi! link perlStatementList       ConnectedCyan
hi! link perlStatementMisc       ConnectedCyan
hi! link perlStatementNetwork    ConnectedCyan
hi! link perlStatementNumeric    ConnectedCyan
hi! link perlStatementProc       ConnectedCyan
hi! link perlStatementPword      ConnectedCyan
hi! link perlStatementRegexp     ConnectedCyan
hi! link perlStatementScalar     ConnectedCyan
hi! link perlStatementSocket     ConnectedCyan
hi! link perlStatementTime       ConnectedCyan
hi! link perlStatementVector     ConnectedCyan

" Highlighting for quoting constructs, tied to existing option in vim-perl
if get(g:, 'perl_string_as_statement', 0)
  hi! link perlStringStartEnd ConnectedRed
endif

" Signatures
hi! link perlSignature           ConnectedOrangeItalic
hi! link perlSubPrototype        ConnectedOrangeItalic

" Hash keys
hi! link perlVarSimpleMemberName ConnectedPurple
" }}}

" PHP: {{{
hi! link phpClass           Type
hi! link phpClasses         Type
hi! link phpDocTags         ConnectedCyanItalic
hi! link phpFunction        Function
hi! link phpParent          Normal
hi! link phpSpecialFunction ConnectedCyan
" }}}

" PlantUML: {{{
hi! link plantumlClassPrivate              SpecialKey
hi! link plantumlClassProtected            ConnectedOrange
hi! link plantumlClassPublic               Function
hi! link plantumlColonLine                 String
hi! link plantumlDirectedOrVerticalArrowLR Constant
hi! link plantumlDirectedOrVerticalArrowRL Constant
hi! link plantumlHorizontalArrow           Constant
hi! link plantumlSkinParamKeyword          ConnectedCyan
hi! link plantumlTypeKeyword               Keyword
" }}}

" PureScript: {{{
hi! link purescriptModule Type
hi! link purescriptImport ConnectedCyan
hi! link purescriptImportAs ConnectedCyan
hi! link purescriptOperator Operator
hi! link purescriptBacktick Operator
" }}}

" Python: {{{
hi! link pythonBuiltinObj    Type
hi! link pythonBuiltinObject Type
hi! link pythonBuiltinType   Type
hi! link pythonClassVar      ConnectedPurpleItalic
hi! link pythonExClass       Type
hi! link pythonNone          Type
hi! link pythonRun           Comment
" }}}

" reStructuredText: {{{
hi! link rstComment                             Comment
hi! link rstTransition                          Comment
hi! link rstCodeBlock                           ConnectedGreen
hi! link rstInlineLiteral                       ConnectedGreen
hi! link rstLiteralBlock                        ConnectedGreen
hi! link rstQuotedLiteralBlock                  ConnectedGreen
hi! link rstStandaloneHyperlink                 ConnectedLink
hi! link rstStrongEmphasis                      ConnectedOrangeBold
hi! link rstSections                            ConnectedPurpleBold
hi! link rstEmphasis                            ConnectedYellowItalic
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

hi! link rubyBlockArgument          ConnectedOrangeItalic
hi! link rubyBlockParameter         ConnectedOrangeItalic
hi! link rubyCurlyBlock             ConnectedPink
hi! link rubyGlobalVariable         ConnectedPurple
hi! link rubyInstanceVariable       ConnectedPurpleItalic
hi! link rubyInterpolationDelimiter ConnectedPink
hi! link rubyRegexpDelimiter        ConnectedRed
hi! link rubyStringDelimiter        ConnectedYellow
" }}}

" Rust: {{{
hi! link rustCommentLineDoc Comment
" }}}

" Sass: {{{
hi! link sassClass                  cssClassName
hi! link sassClassChar              cssClassNameDot
hi! link sassId                     cssIdentifier
hi! link sassIdChar                 cssIdentifier
hi! link sassInterpolationDelimiter ConnectedPink
hi! link sassMixinName              Function
hi! link sassProperty               cssProp
hi! link sassVariableAssignment     Operator
" }}}

" Shell: {{{
hi! link shCommandSub NONE
hi! link shEscape     ConnectedRed
hi! link shParen      NONE
hi! link shParenError NONE
" }}}

" Tex: {{{
hi! link texBeginEndName  ConnectedOrangeItalic
hi! link texBoldItalStyle ConnectedOrangeBoldItalic
hi! link texBoldStyle     ConnectedOrangeBold
hi! link texInputFile     ConnectedOrangeItalic
hi! link texItalStyle     ConnectedYellowItalic
hi! link texLigature      ConnectedPurple
hi! link texMath          ConnectedPurple
hi! link texMathMatcher   ConnectedPurple
hi! link texMathSymbol    ConnectedPurple
hi! link texSpecialChar   ConnectedPurple
hi! link texSubscripts    ConnectedPurple
hi! link texTitle         ConnectedFgBold
" }}}

" Typescript: {{{
hi! link typescriptAliasDeclaration       Type
hi! link typescriptArrayMethod            Function
hi! link typescriptArrowFunc              Operator
hi! link typescriptArrowFuncArg           ConnectedOrangeItalic
hi! link typescriptAssign                 Operator
hi! link typescriptBOMWindowProp          Constant
hi! link typescriptBinaryOp               Operator
hi! link typescriptBraces                 Delimiter
hi! link typescriptCall                   typescriptArrowFuncArg
hi! link typescriptClassHeritage          Type
hi! link typescriptClassName              Type
hi! link typescriptDateMethod             ConnectedCyan
hi! link typescriptDateStaticMethod       Function
hi! link typescriptDecorator              ConnectedGreenItalic
hi! link typescriptDefaultParam           Operator
hi! link typescriptES6SetMethod           ConnectedCyan
hi! link typescriptEndColons              Delimiter
hi! link typescriptEnum                   Type
hi! link typescriptEnumKeyword            Keyword
hi! link typescriptFuncComma              Delimiter
hi! link typescriptFuncKeyword            Keyword
hi! link typescriptFuncType               ConnectedOrangeItalic
hi! link typescriptFuncTypeArrow          Operator
hi! link typescriptGlobal                 Type
hi! link typescriptGlobalMethod           ConnectedCyan
hi! link typescriptGlobalObjects          Type
hi! link typescriptIdentifier             ConnectedPurpleItalic
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
hi! link typescriptParamImpl              ConnectedOrangeItalic
hi! link typescriptParens                 Delimiter
hi! link typescriptPredefinedType         Type
hi! link typescriptRestOrSpread           Operator
hi! link typescriptTernaryOp              Operator
hi! link typescriptTypeAnnotation         Special
hi! link typescriptTypeCast               Operator
hi! link typescriptTypeParameter          ConnectedOrangeItalic
hi! link typescriptTypeReference          Type
hi! link typescriptUnaryOp                Operator
hi! link typescriptVariable               Keyword

hi! link tsxAttrib           ConnectedGreenItalic
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
hi! link xmlAttrib  ConnectedGreenItalic
hi! link xmlEqual   Operator
hi! link xmlTag     Delimiter
hi! link xmlTagName Statement

" Fixes missing highlight over end tags
syn region xmlTagName
	\ matchgroup=xmlTag start=+</[^ /!?<>"']\@=+
	\ matchgroup=xmlTag end=+>+
" }}}

" YAML: {{{
hi! link yamlAlias           ConnectedGreenItalicUnderline
hi! link yamlAnchor          ConnectedPinkItalic
hi! link yamlBlockMappingKey ConnectedCyan
hi! link yamlFlowCollection  ConnectedPink
hi! link yamlFlowIndicator   Delimiter
hi! link yamlNodeTag         ConnectedPink
hi! link yamlPlainScalar     ConnectedYellow
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
    \ 'hl+':     ['fg', 'ConnectedOrange'],
    \ 'info':    ['fg', 'ConnectedPurple'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'ConnectedGreen'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'],
    \}
endif
" }}}

" dense-analysis/ale {{{
hi! link ALEError              ConnectedErrorLine
hi! link ALEWarning            ConnectedWarnLine
hi! link ALEInfo               ConnectedInfoLine

hi! link ALEErrorSign          ConnectedRed
hi! link ALEWarningSign        ConnectedOrange
hi! link ALEInfoSign           ConnectedCyan

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
  " those highlight groups when the defaults do not match the connected
  " specification.
  " https://github.com/nvim-treesitter/nvim-treesitter/blob/master/plugin/nvim-treesitter.vim

  " deprecated TS* highlight groups
  " see https://github.com/nvim-treesitter/nvim-treesitter/pull/3656
  " # Misc
  hi! link TSPunctSpecial Special
  " # Constants
  hi! link TSConstMacro Macro
  hi! link TSStringEscape Character
  hi! link TSSymbol ConnectedPurple
  hi! link TSAnnotation ConnectedYellow
  hi! link TSAttribute ConnectedGreenItalic
  " # Functions
  hi! link TSFuncBuiltin ConnectedCyan
  hi! link TSFuncMacro Function
  hi! link TSParameter ConnectedOrangeItalic
  hi! link TSParameterReference ConnectedOrange
  hi! link TSField ConnectedOrange
  hi! link TSConstructor ConnectedCyan
  " # Keywords
  hi! link TSLabel ConnectedPurpleItalic
  " # Variable
  hi! link TSVariableBuiltin ConnectedPurpleItalic
  " # Text
  hi! link TSStrong ConnectedFgBold
  hi! link TSEmphasis ConnectedFg
  hi! link TSUnderline Underlined
  hi! link TSTitle ConnectedYellow
  hi! link TSLiteral ConnectedYellow
  hi! link TSURI ConnectedYellow
  " HTML and JSX tag attributes. By default, this group is linked to TSProperty,
  " which in turn links to Identifer (white).
  hi! link TSTagAttribute ConnectedGreenItalic

  if has('nvim-0.8.1')
    " # Misc
    hi! link @punctuation.delimiter Delimiter
    hi! link @punctuation.bracket ConnectedFg
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
    hi! link @string.special.symbol ConnectedPurple
    hi! link @string.special.url Underlined
    hi! link @symbol ConnectedPurple
    hi! link @annotation ConnectedYellow
    hi! link @attribute ConnectedGreenItalic
    hi! link @namespace Structure
    hi! link @module Structure
    hi! link @module.builtin Special
    " # Functions
    hi! link @function.builtin ConnectedCyan
    hi! link @funcion.macro Function
    hi! link @function Function
    hi! link @parameter ConnectedOrangeItalic
    hi! link @parameter.reference ConnectedOrange
    hi! link @field ConnectedOrange
    hi! link @property ConnectedFg
    hi! link @constructor ConnectedCyan
    " # Keywords
    hi! link @label ConnectedPurpleItalic
    hi! link @keyword.function ConnectedPink
    hi! link @keyword.operator Operator
    hi! link @keyword Keyword
    hi! link @exception ConnectedPurple
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
    hi! link @variable ConnectedFg
    hi! link @variable.builtin ConnectedPurpleItalic
    hi! link @variable.parameter ConnectedOrangeItalic
    hi! link @variable.member  ConnectedOrange
    " # Text
    hi! link @text ConnectedFg
    hi! link @text.strong ConnectedFgBold
    hi! link @text.emphasis ConnectedFg
    hi! link @text.underline Underlined
    hi! link @text.title ConnectedYellow
    hi! link @text.literal ConnectedYellow
    hi! link @text.uri ConnectedYellow
    hi! link @text.diff.add DiffAdd
    hi! link @text.diff.delete DiffDelete

    hi! link @markup.strong ConnectedFgBold
    hi! link @markup.italic ConnectedFgItalic
    hi! link @markup.strikethrough ConnectedFgStrikethrough
    hi! link @markup.underline Underlined

    hi! link @markup Special
    hi! link @markup.heading ConnectedYellow
    hi! link @markup.link Underlined
    hi! link @markup.link.uri ConnectedYellow
    hi! link @markup.link.label SpecialChar
    hi! link @markup.raw ConnectedYellow
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
    hi! link @tag ConnectedCyan
    hi! link @tag.delimiter ConnectedFg
    " HTML and JSX tag attributes. By default, this group is linked to TSProperty,
    " which in turn links to Identifer (white).
    hi! link @tag.attribute ConnectedGreenItalic
  endif
  " }}}

  " hrsh7th/nvim-cmp {{{
  hi! link CmpItemAbbrDeprecated ConnectedError

  hi! link CmpItemAbbrMatch ConnectedCyan
  hi! link CmpItemAbbrMatchFuzzy ConnectedCyan

  hi! link CmpItemKindText ConnectedFg
  hi! link CmpItemKindMethod Function
  hi! link CmpItemKindFunction Function
  hi! link CmpItemKindConstructor ConnectedCyan
  hi! link CmpItemKindField ConnectedOrange
  hi! link CmpItemKindVariable ConnectedPurpleItalic
  hi! link CmpItemKindClass ConnectedCyan
  hi! link CmpItemKindInterface ConnectedCyan
  hi! link CmpItemKindModule ConnectedYellow
  hi! link CmpItemKindProperty ConnectedPink
  hi! link CmpItemKindUnit ConnectedFg
  hi! link CmpItemKindValue ConnectedYellow
  hi! link CmpItemKindEnum ConnectedPink
  hi! link CmpItemKindKeyword ConnectedPink
  hi! link CmpItemKindSnippet ConnectedFg
  hi! link CmpItemKindColor ConnectedYellow
  hi! link CmpItemKindFile ConnectedYellow
  hi! link CmpItemKindReference ConnectedOrange
  hi! link CmpItemKindFolder ConnectedYellow
  hi! link CmpItemKindEnumMember ConnectedPurple
  hi! link CmpItemKindConstant ConnectedPurple
  hi! link CmpItemKindStruct ConnectedPink
  hi! link CmpItemKindEvent ConnectedFg
  hi! link CmpItemKindOperator ConnectedPink
  hi! link CmpItemKindTypeParameter ConnectedCyan

  hi! link CmpItemMenu Comment
  " }}}

  " lewis6991/gitsigns.nvim {{{
  hi! link GitSignsAdd      DiffAdd
  hi! link GitSignsAddLn    DiffAdd
  hi! link GitSignsAddNr    DiffAdd
  hi! link GitSignsChange   DiffChange
  hi! link GitSignsChangeLn DiffChange
  hi! link GitSignsChangeNr DiffChange

  hi! link GitSignsDelete   ConnectedRed
  hi! link GitSignsDeleteLn ConnectedRed
  hi! link GitSignsDeleteNr ConnectedRed
  " }}}

endif
" }}}

" }}}

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0 et:
