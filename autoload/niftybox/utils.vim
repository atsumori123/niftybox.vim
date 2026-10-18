let s:save_cpo = &cpoptions
set cpoptions&vim

"---------------------------------------------------------------
" メッセージ出力
"---------------------------------------------------------------
function! niftybox#utils#msg(hl, msg) abort
	redraw
	execute 'echohl ' . a:hl | echo a:msg | echohl None
endfunction

"---------------------------------------------------------------
" 1文字入力
"---------------------------------------------------------------
function! niftybox#utils#get_char(prompt) abort
	echohl MoreMsg
	try
		echo a:prompt
		let char = call('getchar', a:000)
	catch /^Vim:Interrupt$/
		let char = 3 " <C-c>
	endtry
	echohl None
	redraw | echo ""

	if char == 27 || char == 3
		" ESC or <C-c> key pressed
		redraw | echo "Cancelled."
		return ''
	endif

	return type(char) == v:t_number ? nr2char(char) : char
endfunction

"---------------------------------------------------------------
" utils#input
"---------------------------------------------------------------
function! niftybox#utils#input(prompt, ...)
	let text = get(a:000, 0, "")
	let completion = get(a:000, 1, "none")

	echohl MoreMsg
	let ret = completion == "none" ? input(a:prompt, text) : input(a:prompt, text, completion)
	echohl None

	return ret
endfunction

"---------------------------------------------------------------
" キャンセル判定付き入力
"---------------------------------------------------------------
function! niftybox#utils#safe_input(prompt, ...)
	let text = get(a:000, 0, "")
	let completion = get(a:000, 1, "none")

	" 事前に現在の入力状態を保存する
	call inputsave()
  
	" input()の入力欄でESCが押されたら、特殊な文字列を入れてEnterを叩くマッピングを動的に定義
	cnoremap <silent><buffer> <Esc> <C-u>__CANCEL__<CR>

	let str = ""
	let is_cancelled = 0

	try
		echohl MoreMsg
		let str = completion == "none" ? input(a:prompt, text) : input(a:prompt, text, completion)
		echohl None

	catch /^Vim:Interrupt$/
		" Esc や Ctrl-C が押された場合、このブロックに入ります
		let is_cancelled = 1

	finally
		" 定義した一時的なマッピングを削除する
		cunmap <buffer> <Esc>
		" 入力状態を元に戻す
		call inputrestore()
	endtry

	" キャンセル判定
	if is_cancelled || str == '__CANCEL__'
		redraw | echo "Cancelled."
		return [v:false, ""]
	endif

	return [v:true, str]
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

