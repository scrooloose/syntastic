"============================================================================
"File:        perl6.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Claudio Ramirez <pub.claudio at gmail dot com>,
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"Ported from: perl6.vim from maintained by 
"             Anthony Carapetis <anthony.carapetis at gmail dot com>,
"             Eric Harmon <http://eharmon.net>
"
"============================================================================
"
" Security:
"
" This checker runs 'perl6 -c' against your file, which in turn executes
" any BEGIN, and CHECK blocks in your file. This is probably fine if you 
" wrote the file yourself, but it can be a problem if you're trying to 
" check third party files. If you are 100% willing to let Vim run the code 
" in your file, set g:syntastic_enable_perl6_checker to 1 in your vimrc 
" to enable this
" checker:
"
"   let g:syntastic_enable_perl6_checker = 1
"
" References:
"
" - https://docs.perl6.org/programs/00-running

if exists('g:loaded_syntastic_perl6_perl6_checker')
    finish
endif
let g:loaded_syntastic_perl6_perl6_checker = 1

if !exists('g:syntastic_perl6_lib_path')
    let g:syntastic_perl6_lib_path = []
endif

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_perl6_perl6_IsAvailable() dict " {{{1
    if exists('g:syntastic_perl6_interpreter')
        let g:syntastic_perl6_perl6_exec = g:syntastic_perl6_interpreter
    endif

    " don't call executable() here, to allow things like
    " let g:syntastic_perl6_interpreter='/usr/bin/env perl6'
    silent! call syntastic#util#system(self.getExecEscaped() . ' -e ' . syntastic#util#shescape('exit(0)'))
    return v:shell_error == 0
endfunction " }}}1

function! SyntaxCheckers_perl6_perl6_GetHighlightRegex(item)
    "if match(a:item['text'], '------>') > -1
    "    let term = split(a:item['text'], '------>')[1]
	"	substitute(term, '⏏', '', '')
	"	substitute(term, '<EOL>', '', '')
    "    return '\V\\<'.term.'\\>'
	"elseif match(a:item['text'], 'Undeclared routine') > -1
    "    let term = split(a:item['text'], 'Undeclared routine')[1]
    "    return '\V\\<'.term.'\\>'
    "endif

    return ''
endfunction

function! SyntaxCheckers_perl6_perl6_GetLocList() dict " {{{1
    if type(g:syntastic_perl6_lib_path) == type('')
        call syntastic#log#oneTimeWarn('variable g:syntastic_perl6_lib_path should be a list')
        let includes = split(g:syntastic_perl6_lib_path, ',')
    else
        let includes = copy(syntastic#util#var('perl6_lib_path'))
    endif

    "Support for PERL6LIB shell environment
    if $PERL6LIB != ''
        let perl6lib = includes + split($PERL6LIB, ':')
        let includes = perl6lib
    endif

    echo includes
    let shebang = syntastic#util#parseShebang()
    let extra = join(map(includes, '"-I" . v:val'))
    "let errorformat = '%f|%l|%m'
    let errorformat = '%f|:|%l|:|%m'
    let makeprg = self.makeprgBuild({ 'args_before': '-c ' . extra })

    let errors = SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'preprocess': 'perl6',
        \ 'defaults': {'type': 'E'} })
    if !empty(errors)
        return errors
    endif

    "let makeprg = self.makeprgBuild({ 'args_before': '-c ' . extra })

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'preprocess': 'perl6',
        \ 'defaults': {'type': 'W'} })
endfunction " }}}1

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'perl6',
    \ 'name': 'perl6',
    \ 'enable': 'enable_perl6_checker'})

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
