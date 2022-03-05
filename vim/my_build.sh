#! /bin/bash

#[vim with python support](https://www.jianshu.com/p/aac78ff576c5)
#[compile vim with python3 support](http://yyq123.blogspot.com/2020/03/vim-with-python3.html)

#sudo make uninstall
#sudo make distclean

#sudo apt install python-dev
#sudo apt install python3-dev
#sudo apt install libncurses5-dev

#git clone https://github.com/vim/vim.git
#cd vim
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --with-ruby-command=/usr/bin/ruby \
            --enable-pythoninterp=yes \
            --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/ \
            --enable-python3interp=yes \
            --with-python3-config-dir=/usr/lib/python3.9/config-3.9-x86_64-linux-gnu/ \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-cscope \ 
            --enable-gui=auto \
            --enable-gtk2-check \
            --enable-fontset \
            --enable-largefile \
            --disable-netbeans \
            --enable-fail-if-missing \
            --with-compiledby="persy" \
            --prefix=/usr/local/bin/vim.d   

#sudo make
#sudo make install
