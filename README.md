This is old one.
If you want new one, visit below.
https://github.com/uesseu/nin-english.vim

# nin-english-vim
A vim plugin for Japanese person, who has to write English ('A`).  
It is based on EJDict, wonderful english-japanese dictionary.  

This plugin offers
- Ddc based asynchronous completion.
- Or ... Omni Completion based on python(from English to Japanese. Ctr-x Ctr-o)
- English to Japanese Dictionary.
- Installing and Updating Dictionary.
- Syntax highlight of English(It may be useful only for me.)

# Speed
The speed of search is relatively good.  
Because these functions are made by deno or python.  
Especially, speed of deno is good.  

# Dependency
- git
- python3 or deno

In case of python, vim or neovim must be compiled with feature of python.  
In case of deno, denops plugin must be installed.  
(Of cource, it must not be vim-tiny.)  

Git is needed only for downloading dictionary.

# Install
for vimplug

```
Plug 'uesseu/nin-english-vim'
```

for dein
```
call dein#add('uesseu/nin-english-vim')
```

And then, you should set 'g:nin_english#dict_dir' and
'g:nin_english#dict_fname'  as global variable in vimrc or init.vim.  
It should be path of dictionary.  

```vim
let g:nin_english#dict_dir = '/home/[user]/.local/share/EJDict'
let g:nin_english#dict_fname = 'dict.txt'
```

# Install dictionary
After you install nin-english-vim, EJDict is needed to run.  
This command download and construct dictionary from this repo.  
https://github.com/kujirahand/EJDict

```vim
EnglishInstall
```

Thanks to EJDict! It is public domain!  

If you want to install dictionary manually,
this dictionary can be downloaded from here.  

https://kujirahand.com/web-tools/EJDictFreeDL.php

# Usage
There are two way to use nin-english-vim.
- Deno and ddc based UI
- Python feature based UI

Deno based UI is faster and python based UI has fewer requirement.

## Deno based UI
In case of deno based ui, completion becomes automatic completion.

### Auto Completion
If you use ddc, ddc completes automatically.  
Ddc completes automatically and quickly.  
However, configuration may be difficult a little.  
This example involves vim-lsp and around plugin.  
Please insert g:nin_english#dict_path into sourceParams.

```vim
call ddc#custom#patch_global('sources', ['vim-lsp', 'around', 'ninenglish'])
call ddc#custom#patch_global('sourceOptions', #{
  \   _: #{
  \     matchers: ['matcher_fuzzy'],
  \     sorters: ['sorter_fuzzy'],
  \     converters: ['converter_fuzzy']
  \   },
  \   around: #{ mark: 'Around'},
  \   ninenglish: #{ mark: 'English'},
  \   vim-lsp: #{
  \     mark: 'LSP',
  \     forceCompletionPattern: '\w+|\.\w*|:\w*|->\w*' },
  \ })
call ddc#custom#patch_global('sourceParams', #{
  \   ninenglish: #{dict_fname: 'g:nin_english#dict_path'}})
```

### Search words
I did not set the key bind of hover.  
This function searches the word on cursor.

```vim
call EnglishSearchDeno()
```

And this command makes 'K' hover like function.

```vim
nnoremap <buffer> K :call EnglishSearch()<CR>
```

## Python based UI
In case of python based ui, you can enable it by typing below at first.  

```vim
EnglishInit
```

### Omni Complete
If you do not use ddc and want to use omni-complete,
you can activate omni-completion by this command.

```vim
:EnglishInit
```

Type as below in insert mode.
```
Ctr-x Ctr-o
```

This is little bit slower and older method than ddc version.

### Search words
Code like below makes 'K' function key to search word.  

```vim
nnoremap <buffer> K :call EnglishSearchPython()<CR>
```

## Pseudo syntax hilight
Running syntax hilight of such language as English is not easy.  
It must be slow and not easy to write program.  
And so, I made pseudo syntax hilight.  
This can be run by this command.

```vim
call NinEnglishHilight()
```
# EJDict format
Perhaps, it may be useful for people in other country,
if there is compatible dictionary.
The dictionary must be TSV format.
EJDict is TSV format like below.

```
[word][tab][mean1; mean2; mean3;...]
```

But I am not sure.  
I am just a Japanese monkey, furthermore am not engineer.
However, this means that... if there is a such format dictionary,
we can use this plugin like English/Japanese case.

# License
License of this software is MIT.  
However, license of EJDict is not MIT.
