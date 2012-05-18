"============================================================================
"File:        mri.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Martin Grenfell <martin.grenfell at gmail dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================
function! SyntaxCheckers_ruby_GetLocList()
    " we cannot set RUBYOPT on windows like that
    if has('win32') || has('win64')
        let makeprg = expand(g:syntastic_ruby_exec).' -W1 -T1 -c '.shellescape(expand('%'))
    else
        let makeprg = 'RUBYOPT= '.expand(g:syntastic_ruby_exec).' -W1 -c '.shellescape(expand('%'))
    endif
    let errorformat =  '%-GSyntax OK,%E%f:%l: syntax error\, %m,%Z%p^,%W%f:%l: warning: %m,%Z%p^,%W%f:%l: %m,%-C%.%#'

    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction
