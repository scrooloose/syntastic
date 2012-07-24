"============================================================================
"File:        coffee.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Lincoln Stoll <l@lds.li>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================
if exists("loaded_coffee_syntax_checker")
    finish
endif
let loaded_coffee_syntax_checker = 1

"bail if the user doesnt have coffee installed
if !executable("coffee")
    finish
endif


function! SyntaxCheckers_coffee_GetLocList()
    let makeprg = 'coffee -c -l -o /tmp '.shellescape(expand('%'))
    let errorformat =  'Syntax%trror: In %f\, %m on line %l,%EError: In %f\, Parse error on line %l: %m,%EError: In %f\, %m on line %l,%W%f(%l): lint warning: %m,%-Z%p^,%W%f(%l): warning: %m,%-Z%p^,%E%f(%l): SyntaxError: %m,%-Z%p^,%-G%.%#'

    let coffee_results = SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
	
	if !empty(coffee_results)
		return coffee_results
	endif
	

    if executable("coffeelint")
      let lint_options = ''
      if(exists('g:coffee_lint_options'))
        let lint_options = g:coffee_lint_options
      endif
      
      let coffeelint = 'coffeelint --csv '.lint_options.' '.shellescape(expand('%'))
      let lint_results = SyntasticMake({ 'makeprg': coffeelint, 'errorformat': '%f\,%l\,%trror\,%m', 'subtype': 'Style' })

      return lint_results
    endif

	return []
endfunction
