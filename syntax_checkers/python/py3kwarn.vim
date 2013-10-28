"============================================================================
"File:        py3kwarn.vim
"Description: Syntax checking plugin for syntastic.vim
"Authors:     Liam Curry <liam@curry.name>
"
"============================================================================
if exists("g:loaded_syntastic_python_py3kwarn_checker")
    finish
endif
let g:loaded_syntastic_python_py3kwarn_checker=1

function! SyntaxCheckers_python_py3kwarn_GetLocList() dict
    let makeprg = syntastic#makeprg#build({
        \ 'exe': 'py3kwarn',
        \ 'checker': self })

    let errorformat = '%W%f:%l:%c: %m'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'python',
    \ 'name': 'py3kwarn'})
