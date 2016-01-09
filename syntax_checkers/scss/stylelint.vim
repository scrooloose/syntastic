"============================================================================
"File:        stylelint.vim
"Description: Syntax checking plugin for syntastic.vim using `stylelint`
"             (https://github.com/stylelint/stylelint).
"Maintainer:  Tim Carry <tim at pixelastic dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================

if exists('g:loaded_syntastic_scss_stylelint_checker')
    finish
endif
let g:loaded_syntastic_scss_stylelint_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_scss_stylelint_GetLocList() dict
    let makeprg = self.makeprgBuild({ 'args_after': '-f json -s "scss"' })

    let errorformat = '%t:%f:%l:%c:%m'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'subtype': 'Style',
        \ 'preprocess': 'stylelint',
        \ 'returns': [0, 1, 2] })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'scss',
    \ 'name': 'stylelint'})

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:

