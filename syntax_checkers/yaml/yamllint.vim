"============================================================================
"File:        yamllint.vim
"Description: YAML files linting for syntastic.vim
"Maintainer:  Adrien Vergé <http://yamllint.readthedocs.org/>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================

if exists('g:loaded_syntastic_yaml_yamllint_checker')
    finish
endif
let g:loaded_syntastic_yaml_yamllint_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_yaml_yamllint_GetLocList() dict
    return SyntasticMake({
        \ 'makeprg': self.makeprgBuild({ 'args_before': '-f parsable' }),
        \ 'errorformat': '%E%f:%l:%c: [error] %m,%W%f:%l:%c: [warning] %m' })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'yaml',
    \ 'name': 'yamllint' })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
