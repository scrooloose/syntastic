"============================================================================
"File:        jsxhint.vim
"Description: Javascript syntax checker - using jsxhint
"Maintainer:  Thomas Boyt <me@thomasboyt.com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"============================================================================

if exists('g:loaded_syntastic_javascript_jsxhint_checker')
    finish
endif
let g:loaded_syntastic_javascript_jsxhint_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_javascript_jsxhint_IsAvailable() dict
    if !executable(self.getExec())
        return 0
    endif

    let command = self.getExecEscaped() . ' --version'
    let ver = self.getVersion(syntastic#util#isRunningWindows() ? command : (command . ' 2>&1'))
    return syntastic#util#versionIsAtLeast(ver, [0, 4, 1])
endfunction

function! SyntaxCheckers_javascript_jsxhint_GetLocList() dict
    let makeprg = self.makeprgBuild({
        \ 'args_after': '--verbose' })

    let errorformat = '%A%f: line %l\, col %v\, %m \(%t%*\d\)'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'defaults': {'bufnr': bufnr('')} })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'javascript',
    \ 'name': 'jsxhint'})

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
