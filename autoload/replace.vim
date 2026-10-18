let s:cpo_save = &cpo
set cpo&vim

"---------------------------------------------------------------
" replace#start
"---------------------------------------------------------------
function! replace#start(range, start, end)
	if a:range
		let tmp = @@
		silent normal! gvy
		let target_pattern = @@
		let @@ = tmp
	else
		let target_pattern = expand('<cword>')
	endif

	let [ret, replace_pattern] = niftybox#utils#safe_input('Replace pattern: ', target_pattern)
	if ret == v:false
		return
	endif

	let [ret, opt] = niftybox#utils#safe_input("Replace option [w(Word Search)] [r(RegExp)] [Start line Number]: ")
	if ret == v:false
		return
	endif

	redraw

	" Regular expression
	let regexp = stridx(opt, 'r') >= 0 ? "\\v" : ""

	" Replace start line
	let start = substitute(opt, "\[^0-9\]", "", "g")
	if empty(start) | let start = 1 | endif

	if stridx(opt, 'w') >= 0
    	exe start.",$s/".regexp."\\<".target_pattern."\\>/".replace_pattern."/gc"
	else
    	exe start.",$s/".regexp.target_pattern."/".replace_pattern."/gc"
	endif
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
