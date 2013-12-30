"============================================================================
"File:        jshint.vim
"Description: Javascript syntax checker - using jshint
"Maintainer:  Martin Grenfell <martin.grenfell at gmail dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"============================================================================

if exists('g:loaded_syntastic_javascript_jshint_checker')
    finish
endif
let g:loaded_syntastic_javascript_jshint_checker=1

if !exists('g:syntastic_jshint_exec')
    let g:syntastic_jshint_exec = 'jshint'
endif

function! SyntaxCheckers_javascript_jshint_IsAvailable()
		if exists("g:syntastic_javascript_jshint_exe")
			return executable(g:syntastic_javascript_jshint_exe)
		else
			return executable('jshint')
		endif
endfunction

function! SyntaxCheckers_javascript_jshint_GetLocList() dict
    let jshint_new = s:JshintNew()
    let makeprg = self.makeprgBuild({
        \ 'exe': expand(g:syntastic_jshint_exec),
        \ 'post_args': (jshint_new ? ' --verbose ' : '') . s:Args() })

		if exists("g:syntastic_javascript_jshint_errorformat")
			let errorformat = g:syntastic_javascript_jshint_errorformat
		else
			let errorformat = jshint_new ?
					\ '%f: line %l\, col %c\, %m \(%t%*\d\)' :
					\ '%E%f: line %l\, col %c\, %m'
		endif

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'defaults': {'bufnr': bufnr('')} })
endfunction

function! s:JshintNew()
    return syntastic#util#versionIsAtLeast(syntastic#util#getVersion(expand(g:syntastic_jshint_exec) . ' --version'), [1, 1])
endfunction

function! s:Args()
    " node-jshint uses .jshintrc as config unless --config arg is present
    return !empty(g:syntastic_javascript_jshint_conf) ? ' --config ' . g:syntastic_javascript_jshint_conf : ''
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'javascript',
    \ 'name': 'jshint'})

