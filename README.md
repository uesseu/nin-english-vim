# nin-english-vim
A vim plugin for Japanese person, who has to write English ('A`).  

This plugin offers
- Omni Completion (from English to Japanese. Ctr-x Ctr-o)
- English to Japanese Dictionary(Ctr-k)
- Installing and Updating Dictionary.
- Syntax highlight of English(It may be useful only for me.)

The speed of search is relatively good.(By python)


Perhaps, it may be useful for other people, if there is compatible dictionary.
The dictionary must be TSV format.
But I am not sure. I am just a Japanese monkey.

# Dependency
- git
- python

Vim or neovim has to use python.
Git is needed only for downloading dictionary.

# Install
for vimplug

```
Plug 'uesseu/nin-english-vim'
```

for dein
```
call dein#add('roxma/nvim-yarp')
```

# Install dictionary automatically
This command download and construct dictionary.

```vim
NinEn2JpInstall
```

# Install dictionary manually
This plugin uses dictionary in this repository.
```
https://github.com/kujirahand/EJDict
```
The dictionary can be downloaded from below.  
<a src='https://kujirahand.com/web-tools/ejdictfreedl.php'>https://kujirahand.com/web-tools/ejdictfreedl.php</a>

However... it is tireing to opening browser, click, unzip, and set a vim variable!
If you are not a lazy person, this is a variable you need to write.

```vim
let g:nin_english#dict = "path/to/dictionary"
```

# Configure
Since I am not good at English, syntax highlight is usefull for me.
If you do not want syntax hilight, you can set below 0.

```vim
let g:nin_english#hilight = 1
```

# Usage
## Omni Complete
Type as below in insert mode.

```
Ctr-x Ctr-o
```

## Search words
Type as below in normal mode.

```
K
```
