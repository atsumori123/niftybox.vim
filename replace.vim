"---------------------------------------------------------------
" replace
"---------------------------------------------------------------
function! Replace(mode) abort
	if a:mode ==# 'v'
		let tmp = @@
		silent normal! gvy
		let select_pattern = @@
		let @@ = tmp
	else
		let select_pattern = expand('<cword>')
	endif

	let target_pattern = input('Target pattern: ', select_pattern)
	if empty(target_pattern) | return | endif

	let replace_pattern = input('Replace pattern: ', target_pattern)

	let opt = input("Replace option [w(Word Search)] [r(RegExp)] [Start line Number]: ")
	if empty(opt) | let opt = "1" | endif

	" コマンドラインクリア
	echo "\r"
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
