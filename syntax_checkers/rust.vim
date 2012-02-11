"============================================================================
"File:        ruby.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Chad Jablonski <chad.jablonski at gmail dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================
if exists("loaded_rust_syntax_checker")
    finish
endif
let loaded_rust_syntax_checker = 1

"bail if the user doesnt have ruby installed
if !executable("rustc")
    finish
endif

function! SyntaxCheckers_rust_GetLocList()
    let makeprg = 'rustc --parse-only '.shellescape(expand('%'))

    let errorformat  = '%E%f:%l:%c: \\d%#:\\d%# [1;31merror:[0m %m,'   .
                     \ '%W%f:%l:%c: \\d%#:\\d%# [1;33mwarning:[0m %m,' .
                     \ '%C%f:%l %m,' .
                     \ '%-Z%.%#'

    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction


