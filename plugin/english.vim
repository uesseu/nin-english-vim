scriptencoding utf-8
" nin_english
" Last Change:	2019 Sep 27
" Maintainer:	Ninja <sheepwing@kyudai.jp>
" License:	Mit licence
command! EnglishInit call NinEnglishInit()
command! EnglishIndent call NinEnglishIndent()

if exists('g:loaded_nin_english')
  finish
endif
let g:loaded_nin_english = 1

if !exists('g:nin_english#hilight')
  let g:nin_english#hilight = 1
endif

let s:save_cpo = &cpo
set cpo&vim

function! NinEnglishInit ()
  if g:nin_english#hilight == 1
    sy match Number /\d\+/
    sy match Float /\dth/
    sy match Label /\u\+/
    sy match Label /\w*\u\w*/
    sy region Identifier start=+#+ end=+\n+
    sy keyword Comment a the

    sy keyword Number January Jan February Feb March Mar April Apr May May June Jun July Jul
    sy keyword Number fourteen fifteen sixteen seventeen eighteen nineteen twelve

    sy case ignore
    sy keyword Number one two three four five six seven eight nine ten eleven twelve thiteen
    sy match Operator /[\+\-\*]/
    sy match Float /\d*\.\d+/

    sy keyword Operator is are was were will would wish can be been have has either nor neither may
    sy keyword Number Augus Aug September Sep Sept October Oct November Nov December Dec
    sy match Label /for example\,\?/
    sy keyword Operator on of in to at above by before due goind within over both into under
    sy keyword Function when where while thus whether that if during
    sy keyword Function which with

    sy keyword Keyword too further
    sy match Operator /has been/
    sy keyword Operator but however so yet
    sy keyword Operator for as via about
    sy keyword Operator and or of because not
    sy keyword Operator also
    sy keyword Operator such
    sy keyword Operator between
    sy keyword Operator + - % *
    sy keyword Operator than more less

    sy keyword Special significant significantly

    sy keyword Constant we you I
    sy keyword Constant this it its there those

    sy keyword Comment etal
    sy match Comment /et al/

    sy match Special /\. /
    sy match Special /\,/
    sy match Special /\;/
    sy match Special /\:/
    sy keyword Operator from
    sy region String start=+"+ end=+"+
    sy region String start=+\[+ end=+\]+
    sy region String start=+(+ end=+)+

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
nnoremap K :call EnglishSearch()<CR>
let g:nin_english#dict_loaded = 1
endif
endfunction

function! EnglishSearch ()
python3 << search_token
import vim
token = vim.eval('expand("<cword>")').lower()
tokens = [token, token[:-1], token[:-2], token[:-3],
          token[1:], token[2:], token[3:]]
tokens += list(map(lambda x: x + 'e', tokens))
tokens += list(map(lambda x: x + 'y', tokens))
detected = False
for t in tokens:
    if t in nin_eng_dict:
        print(t + ':')
        print(nin_eng_dict[t].replace('/', '\n'))
        detected = True
        break
if not detected:
    print('Not found')
search_token
endfunction

autocmd BufRead,BufNewFile *.md call NinEnglishInit()
autocmd BufRead,BufNewFile *.txt call NinEnglishInit()

fun! NinEnglishComplete(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  else
    " find months matching with "a:base"
    let res = []

if !exists("g:nin_english#comp")
let g:nin_english#comp = []
python3 << collect_word
import vim
for n in nin_eng_dict.keys():
    if (len(n) > 3) and ('[' not in n):
        vim.command('call add(g:nin_english#comp, "{}")'.format(n))
collect_word
endif
    for m in g:nin_english#comp
      if m =~ '^' . a:base
        call add(res, m)
      endif
    endfor
    return res
  endif
endfun
set omnifunc=NinEnglishComplete

let &cpo = s:save_cpo
unlet s:save_cpo

function! NinEnglishIndent()
  execute "%s/(/\r    (/g"
  execute "%s/,/,\r  /g"
  execute "%s/\\. /\\.\r/g"
endfunction
