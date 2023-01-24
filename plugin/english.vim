scriptencoding utf-8
" nin_english
" Last Change:	2021 Jan 18
" Maintainer:	Shoichiro Nakanishi <sheepwing@kyudai.jp>
" License:	Mit licence


command! EnglishInit call NinEnglishInit()
command! EnglishIndent call NinEnglishIndent()
command! EnglishInstall call NinEnglishInstall()
if !exists('g:nin_english#hilight')
  let g:nin_english#dict = $HOME."/.vim/plugged/nin-english-vim/EJDict/dict.txt"
endif
"setlocal spell spelllang=en_us
function! NinCloseHoverFloat() abort
    call nvim_win_close(g:nin_win, v:true)
    augroup nin_win
        autocmd!
    augroup END
endfunction

function! NinHoverFloat(texts) abort
    if has('nvim')
        let buf = nvim_create_buf(v:false, v:true)
        call nvim_buf_set_lines(buf, 0, -1, v:true, a:texts)
        let tmplen = 0
        let width = 0
        let height = 1
        for s in a:texts
            let tmplen = strdisplaywidth(s)
            if tmplen > width
                let width = tmplen
                let height += 1
            endif
        endfor
        let opts = {'relative': 'cursor', 'width': width,
                    \'height': height, 'col': 0, 'row': 1,
                    \'anchor': 'NW', 'style': 'minimal'} 
        let g:nin_win = nvim_open_win(buf, 0, opts)
        augroup nin_win
            autocmd!
            autocmd CursorMoved,CursorMovedI,InsertEnter <buffer> call NinCloseHoverFloat()
        augroup END
    else
        call popup_atcursor(a:texts, {})
    endif
endfunction


function! NinEn2JpInstall() abort
  !git clone https://github.com/kujirahand/EJDict $HOME/.vim/plugged/nin-english-vim/EJDict
  !git clone https://github.com/kujirahand/EJDict $HOME/.vim/EJDict
  !cat $HOME/.vim/plugged/nin-english-vim/EJDict/src/* > $HOME/.vim/plugged/nin-english-vim/EJDict/dict.txt
endfunction

if exists('g:loaded_nin_english')
  finish
endif
let g:loaded_nin_english = 1

if !exists('g:nin_english#hilight')
  let g:nin_english#hilight = 1
endif
if !exists('g:nin_english#dict')
  let g:nin_english#dict = $HOME."/.vim/plugged/nin-english-vim/EJDict/dict.txt"
  if !filereadable(g:nin_english#dict)
    call NinEn2JpInstall()
  endif
endif

let s:save_cpo = &cpo
set cpo&vim

function! NinEnglishInit () abort
  if g:nin_english#hilight == 1
    sy match Number /\d\+/
    sy match Float /\dth/
    sy match Label /\u\+/
    sy match Label /\w*\u\w*/
    sy keyword Comment a the

    sy keyword Number January Jan February Feb March Mar April Apr May May June Jun July Jul
    sy keyword Number Augus Aug September Sep Sept October Oct November Nov December Dec
    sy keyword Number one two three four five six seven eight nine ten eleven twelve thirteen
    sy keyword Number fourteen fifteen sixteen seventeen eighteen nineteen twenty
    sy keyword Number thirty forty fifty sixty seventy eighty ninety hundred thousand
    sy keyword Number mili kilo mega giga

    sy case ignore
    sy match Operator /[\+\-\*]/
    sy match Float /\d*\.\d+/

    sy keyword Operator is are was were will would wish do shall should
    sy keyword Operator can be been have has either nor neither may
    sy match Label /for example\,\?/
    sy keyword Operator on of in to at above by before due goind within over both into under
    sy keyword Function when where while thus whether that if during
    sy keyword Function which with

    sy keyword Keyword too further
    sy match Operator /has been/
    sy keyword Operator but however so yet
    sy keyword Operator for as via about
    sy keyword Operator and or of because not since after
    sy keyword Operator also more less seems
    sy keyword Operator such better worse
    sy keyword Operator between
    sy keyword Operator + - % *
    sy keyword Operator than more less

    sy keyword Special significant significantly

    sy keyword Constant we you I he she they
    sy keyword Constant this it its there those

    sy keyword Comment etal
    sy match Comment /et al/

    sy match Special /\. /
    sy match Special /\,/
    sy match Special /\;/
    sy match Special /\:/
    "sy match Special /\"/
    sy keyword Operator from
    sy region String start=+"+ end=+"+
    sy region String start=+\[+ end=+\]+
    sy region String start=+(+ end=+)+
    sy region String start=+{+ end=+}+

    sy match Typedef /^\u\w*/
    sy match Typedef /\. \+\u\w*/
    sy case match
  endif

  if !exists('g:nin_english#dict_loaded')
python3 << read_dict
import vim
with open(vim.eval('g:nin_english#dict')) as fp:
    tokens = list(map(lambda x: x.split('\t'), fp.readlines()))
    nin_eng_dict = dict(zip([x[0] for x in tokens], [x[1] for x in tokens]))
read_dict
  set omnifunc=NinEnglishComplete
  let g:nin_english#dict_loaded = 1
  endif
endfunction

function! EnglishSearch () abort
  python3 << search_token
import vim
from itertools import product
from functools import reduce
from operator import add
token = vim.eval('expand("<cword>")').lower()
tokens = [token]
suffix = ['', 's', 'es', 'ed', 'is', 'ly', 'ing', 'able', 'lize', 'lized']
prefix = ['', 'a', 'bi', 'pre', 'mul', 'non', 'hyper']

length = len(token)
for p, s in product(prefix, suffix):
    if token[length-len(s):] == s and token[:len(p)] == p:
        tokens.append(token[len(p):length-len(s)])
print(tokens)
detected = False
for t in tokens:
    if t in nin_eng_dict:
        word = [s.strip() for s in [t + ':', *nin_eng_dict[t].split('/')]]
        # word = reduce(add, [w.split('\n') for w in word])
        vim.eval(f'NinHoverFloat({word})')
        detected = True
        break
if not detected:
    vim.eval(f'NinHoverFloat(["Not found..."])')
search_token
endfunction


fun! NinEnglishComplete(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  endif

  let result = []
python3 << collect_word
import vim
base = vim.eval('a:base')
if base:
    for key, value in (n for n in nin_eng_dict.items() if base == n[0][:len(base)]):
        value = value.replace('"', '\'').replace('/', '\n')
        vim.command(f'call add(result, {{"word": "{key}", "info": "{value}"}})')
collect_word
  return result
endfun

function! NinEnglishIndent()
  set shiftwidth=4
  set tw=80
  %s/-\n/-/g
  %s/\n/\r    /g
  %s/\.[\r ]*\([A-Z]\)\@=/\.\r/g
endfunction

autocmd BufLeave set omnifunc=''
let &cpo = s:save_cpo
unlet s:save_cpo
