"============================================================================
"File:        cuda.vim
"Description: Syntax checking plugin for syntastic
"Author:      Hannes Schulz <schulz at ais dot uni-bonn dot de>
"
"============================================================================

if exists('g:loaded_syntastic_cuda_nvcc_checker')
    finish
endif
let g:loaded_syntastic_cuda_nvcc_checker = 1

if !exists('g:syntastic_cuda_config_file')
    let g:syntastic_cuda_config_file = '.syntastic_cuda_config'
endif

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_cuda_nvcc_GetLocList() dict
    let arch_flag = syntastic#util#var('cuda_arch')
    if arch_flag !=# ''
        let arch_flag = ' -arch=' . arch_flag
    endif

    let build_opts = {}
    if index(['h', 'hpp', 'cuh'], expand('%:e', 1), 0, 1) >= 0
        if syntastic#util#var('cuda_check_header', 0)
            let build_opts = {
                \ 'exe_before': 'echo > .syntastic_dummy.cu ;',
                \ 'fname_before': '.syntastic_dummy.cu -include' }
        else
            return []
        endif
    endif

    call extend(build_opts, {
        \ 'args_before': '--cuda -O0 -I .' . arch_flag,
        \ 'args': syntastic#c#ReadConfig(g:syntastic_cuda_config_file),
        \ 'args_after': '-Xcompiler -fsyntax-only',
        \ 'tail_after': syntastic#c#NullOutput() })

    let makeprg = self.makeprgBuild(build_opts)

    let errorformat =
        \ '%*[^"]"%f"%*\D%l: %m,'.
        \ '"%f"%*\D%l: %m,'.
        \ '%-G%f:%l: (Each undeclared identifier is reported only once,'.
        \ '%-G%f:%l: for each function it appears in.),'.
        \ '%f:%l:%c:%m,'.
        \ '%f(%l):%m,'.
        \ '%f:%l:%m,'.
        \ '"%f"\, line %l%*\D%c%*[^ ] %m,'.
        \ '%D%*\a[%*\d]: Entering directory `%f'','.
        \ '%X%*\a[%*\d]: Leaving directory `%f'','.
        \ '%D%*\a: Entering directory `%f'','.
        \ '%X%*\a: Leaving directory `%f'','.
        \ '%DMaking %*\a in %f,'.
        \ '%f|%l| %m'

    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'cuda',
    \ 'name': 'nvcc'})

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
