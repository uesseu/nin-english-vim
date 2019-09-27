# nin-english-vim
A vim plugin for Japanese.
Perhaps, it may be useful for other people,
if there is compatible dictionary.
But I am not sure. I am just a Japanese monkey.

# Install
for vimplug

```
Plug 'uesseu/nin-english-vim'
```

for dein
```
call dein#add('roxma/nvim-yarp')
```

If you are Japanese, download this dictionary.
https://kujirahand.com/web-tools/EJDictFreeDL.php

After downloading dictionary, unzip the file and write vimrc.

```vim
let g:nin_english#dict = "path/to/dictionary"
```

# Configure

If you dont want syntax hilight, you can set below 0.
```vim
let g:nin_english#hilight = 1
```

# Omni Complete
Type as below in insert mode.

```
Ctr-x Ctr-o
```

# Search words
Type as below in normal mode.

```
K
```
