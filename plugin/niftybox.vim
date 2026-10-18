if exists('g:loaded_niftybox')
	finish
endif
let g:loaded_niftybox = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

command! -nargs=0 -range Replace call replace#start(<range>, <line1>, <line2>)

let &cpoptions = s:save_cpo
unlet s:save_cpo
