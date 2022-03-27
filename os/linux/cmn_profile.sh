#alias share_files2='sudo mount -t cifs -o username="Administrator",password="xxxxx" //192.168.0.2/share_files /media/username/share_files2'

addToPath(){
    #if [[ $PATH =~ $1 ]] then
        #return
    #fi
    if [ -d $1 ] ; then
        # tmux会修改PATH的顺序,所以要先删除已存在的路径,来保证顺序
        PATH=${PATH/$1:/}
        PATH=${PATH/:$1/}
        PATH=$1:$PATH
    fi
}
addToPath "$HOME/bin"
addToPath "$HOME/.local/bin"
addToPath "$HOME/a/git/lang/py/setup/dev/os/linux/sh"
addToPath "/opt/anaconda3/bin"

if [[ `uname` == "Linux" ]]; then
    if [ -n "$BASH_VERSION" ]; then
        source /usr/share/doc/fzf/examples/completion.bash
        source /usr/share/doc/fzf/examples/key-bindings.bash
        [[ -s /usr/share/autojump/autojump.bash ]] && . /usr/share/autojump/autojump.bash
    fi
    if [ -n "$ZSH_VERSION" ]; then
        source /usr/share/doc/fzf/examples/completion.zsh
        source /usr/share/doc/fzf/examples/key-bindings.zsh
        [[ -s /usr/share/autojump/autojump.zsh ]] && . /usr/share/autojump/autojump.zsh
    fi
else
    if [ -n "$BASH_VERSION" ]; then
        [[ -s $(brew --prefix)/etc/profile.d/[autojump.sh](http://autojump.sh/) ]] && . $(brew --prefix)/etc/profile.d/[autojump.sh](http://autojump.sh/)
    fi
    if [ -n "$ZSH_VERSION" ]; then
        [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
    fi
    export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
fi

# Use \ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='\'

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_TMUX=1
export FZF_TMUX_HEIGHT='80%'
export GTAGSLABEL='native-pygments'
export GTAGSCONF='/usr/local/share/gtags/gtags.conf'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude={.git,.svn,.idea,.vscode,.sass-cache,node_modules,build,.vimroot,__pycache__} . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude={.git,.svn,.idea,.vscode,.sass-cache,node_modules,build,.vimroot,__pycache__} . "$1"
}

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}

# usage: _fzf_setup_completion path|dir|var|alias|host COMMANDS...
#_fzf_setup_completion path ag git kubectl
#_fzf_setup_completion dir tree

# Custom fuzzy completion for "doge" command
#   e.g. doge **<TAB>
_fzf_complete_doge() {
  _fzf_complete --multi --reverse --prompt="doge> " -- "$@" < <(
    echo very
    echo wow
    echo such
    echo doge
  )
}

_fzf_complete_foo() {
  _fzf_complete --multi --reverse --header-lines=3 -- "$@" < <(
    ls -al
  )
}

_fzf_complete_foo_post() {
  awk '{print $NF}'
}

[ -n "$BASH" ] && complete -F _fzf_complete_foo -o default -o bashdefault foo

export FZF_DEFAULT_COMMAND='fd --type f --follow --exclude={.git,.svn,.idea,.vscode,.sass-cache,node_modules,build,.vimroot,__pycache__}'

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"

if [ -n "$ZSH_VERSION" ]; then
    DISABLE_AUTO_UPDATE="true"
fi
export EDITOR="nvim"
export PAGER=less
export LESS=-R
export http_proxy=http://proxy.izds.top:63001
export https_proxy=$http_proxy
export HOMEBREW_NO_AUTO_UPDATE=true

alias vif='nvim $(vifm --choose-file -)'
alias vid='cd $(vifm --choose-dir -)'
alias dtvp='sudo mount /dev/sr0 /media/cdrom0'
alias pc='proxychains4'
#alias i2p='sudo i2pd --conf=~/.i2pd/i2pd.conf --tunconf=~/.i2pd/tunnels.conf --tunnelsdir=~/.i2pd/tunnels.conf.d'
viF(){
    local filepath=$(vifm --choose-file -)
    dir=$(dirname "$filepath")
    cd $dir ; nvim $filepath
}

# put at last
if [ "$TERM" = "linux" ]; then
	alias fbterm='LANG=zh_CN.UTF-8 fbterm'
	export TERM=fbterm
	#fbterm ; tmux
	fbterm
fi
