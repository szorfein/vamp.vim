" Palette: {{{

let g:vamp#palette           = {}
let g:vamp#palette.fg        = ['#DBE7F7', 253] "theme4

let g:vamp#palette.bglighter = ['#17263B', 238] "theme3 variant
let g:vamp#palette.bglight   = ['#0F1927', 237] "theme3
let g:vamp#palette.bg        = ['#0E1724', 236] "theme2
let g:vamp#palette.bgdark    = ['#0C141F', 235] "theme1
let g:vamp#palette.bgdarker  = ['#0A121D', 234] "theme0

let g:vamp#palette.comment   = ['#6B48D5',  61] "theme15 variant dark
let g:vamp#palette.selection = ['#0F1927', 239] "theme3
let g:vamp#palette.subtle    = ['#1A192A', 238]

let g:vamp#palette.orange    = ['#90C882', 215] "theme11

let g:vamp#palette.red       = ['#90D0BA', 203] "theme12
let g:vamp#palette.green     = ['#DD55BB', 121] "theme14
let g:vamp#palette.yellow    = ['#DD5376', 228] "theme13

let g:vamp#palette.purple    = ['#8669DD', 141] "theme15
let g:vamp#palette.pink      = ['#9234BF', 212] "theme8
let g:vamp#palette.cyan      = ['#CC57BE', 117] "theme9
"
" ANSI
"
let g:vamp#palette.color_0  = '#0A121D' "theme0
let g:vamp#palette.color_1  = '#90C883' "theme11
let g:vamp#palette.color_2  = '#DD55BB' "theme14
let g:vamp#palette.color_3  = '#DD5376' "theme13
let g:vamp#palette.color_4  = '#8669DD' "theme15
let g:vamp#palette.color_5  = '#CC57BE' "theme9
let g:vamp#palette.color_6  = '#B051DD' "theme7
let g:vamp#palette.color_7  = '#E5EEF9' "theme5

let g:vamp#palette.color_8  = '#0E1724' "theme2
let g:vamp#palette.color_9  = '#90D0BA' "theme12
let g:vamp#palette.color_10 = '#E166C2' "theme14 variant
let g:vamp#palette.color_11 = '#E16684' "theme13 variant
let g:vamp#palette.color_12 = '#947AE1' "theme15 variant
let g:vamp#palette.color_13 = '#AC389C' "theme10
let g:vamp#palette.color_14 = '#9234BF' "theme8
let g:vamp#palette.color_15 = '#E9F2FF' "theme6

" }}}

" Helper function that takes a variadic list of filetypes as args and returns
" whether or not the execution of the ftplugin should be aborted.
func! vamp#should_abort(...)
    if ! exists('g:colors_name') || g:colors_name !=# 'vamp'
        return 1
    elseif a:0 > 0 && (! exists('b:current_syntax') || index(a:000, b:current_syntax) == -1)
        return 1
    endif
    return 0
endfunction

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0:
