##############################################################
# プラグイン

# zplug
source ~/.zplug/init.zsh

# plugins
zplug "b4b4r07/enhancd", use:init.sh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"

if ! zplug check --verbose; then
  printf 'Install? [y/N]: '
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose

##############################################################
# 色関係

# 色
autoload -U colors
colors

# ls, grepの色付け(自動)
eval "`dircolors -b`"
# alias ls='ls -xtr --color=auto'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# ls(grepも?)の色付け
# eval $(dircolors $HOME/Dropbox/initfiles/customized-cobalt.dircolors) # customized-cobalt
eval $(dircolors $HOME/Dropbox/initfiles/onedark.dircolors) # onedark

# コマンドライン入力文字色の変更
# zle_highlight=(default:fg=#8D9898) # customized-cobalt
zle_highlight=(default:fg=#ABB2BF) # onedark

export TERM=xterm-256color

# 色一覧の表示
function 256colortest() {
    local code
    for code in {0..256}; do
        echo -n -e "\e[38;05;${code}m $code"
    done
    echo ""
}

# True Colorのグラデーションの表示
alias showtruecolor="curl -s https://gist.githubusercontent.com/lifepillar/09a44b8cf0f9397465614e622979107f/raw/24-bit-color.sh | bash"

##############################################################
# 補完関係

# 補完
autoload -U compinit
compinit -u

# その他補完
setopt auto_param_keys
setopt list_packed
setopt correct

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors \
    $(dircolors -b | sed -e "s/'//" -e "s/^LS_COLORS=//" | head -n 1 | tr : ' ')
if [ -n "LS_COLORS" ]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# # http://mimosa-pudica.net/zsh-incremental.html
# source $HOME/.zsh/incr-0.2.zsh

###############################################################
# プロンプト関係

# local p_info="%F{114}%n@%m%f %F{180}[%d]%f %F{38}%*%f" # username@hostname [path]
# local p_info="%F{39}%n@%m%f %F{39}[%d]%f" # username@hostname [path]
if [ -n "$SSH_CONNECTION" ]; then
    local p_info="%F{38}[SSH]%f %F{39}%n@%m:%d%f" # username@hostname:path
else
    local p_info="%F{39}%n@%m:%d%f" # username@hostname:path
fi
local p_mark="%(?,%F{180},%F{204})%(!,#,$)%f"
PROMPT="$p_info
$p_mark "

#############################################################
# その他

# ディレクトリ移動の設定とか
setopt autocd
setopt autopushd

# 履歴
HISTSIZE=50000
SAVEHIST=100000
HISTFILE=$HOME/.zsh/zsh_history
setopt hist_ignore_dups
setopt share_history

#############################################################
# エイリアス

alias v="vim"
alias p="python"
alias e="evince"

alias l="ls"
alias lsl="ls -xtrlh"
alias dudh="du -d1 -h ."
alias count_files="ls -U | wc -l"

alias pingg="ping www.google.com"
alias mozc_dict="/usr/lib/mozc/mozc_tool -mode=dictionary_tool"
alias muhenkan="xmodmap -e 'keysym Muhenkan = Super_L'"
alias countmainpdf="pdftotext main.pdf - | tr -d '.' | wc -w"

alias stats_files="python -m stats_files"
alias rename_files="python -m rename_files"
alias copy_files="python -m copy_files"
alias safe_mv="python -m safe_mv"
alias tably="python -m tably"

#############################################################
# 環境変数

# virtualenv
source $HOME/env36/bin/activate

# my own libraries
export PYTHONPATH=$HOME/Dropbox/projects/library/commandline_utils_py:$PYTHONPATH
export PYTHONPATH=$HOME/Dropbox/projects/library/utils:$PYTHONPATH
export PYTHONPATH=$HOME/Dropbox/projects/library/treetk:$PYTHONPATH
export PYTHONPATH=$HOME/Dropbox/projects/library/textpreprocessor:$PYTHONPATH
export PYTHONPATH=$HOME/Dropbox/projects/library/dimensionreduction:$PYTHONPATH
export PYTHONPATH=$HOME/Dropbox/projects/library/clustering:$PYTHONPATH
export PYTHONPATH=$HOME/Dropbox/projects/library/visualizers:$PYTHONPATH
export PATH=$HOME/Dropbox/projects/library/gdrive/personal:$PATH

# CUDA
export CUDA_ROOT=/usr/local/cuda
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/lib:$LD_LIBRARY_PATH
export CPATH=/usr/local/cuda/include:$CPATH
export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH
export CUDA_PATH=/usr/local/cuda:$CUDA_PATH

# Stanford CoreNLP
export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/*:$CLASSPATH
# export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/stanford-corenlp-3.9.2.jar:$CLASSPATH
# export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/stanford-corenlp-3.9.2-models.jar:$CLASSPATH
# export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/ejml-0.23.jar:$CLASSPATH
# export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/javax.activation-api-1.2.0.jar:$CLASSPATH
# export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/javax.json.jar:$CLASSPATH
# export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/jaxb-core-2.3.0.1.jar:$CLASSPATH
# export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/jaxb-impl-2.4.0-b180830.0438.jar:$CLASSPATH
# export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/joda-time.jar:$CLASSPATH
# export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/jollyday.jar:$CLASSPATH
# export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/protobuf.jar:$CLASSPATH
# export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/slf4j-api.jar:$CLASSPATH
# export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/slf4j-simple.jar:$CLASSPATH
# export CLASSPATH=$HOME/software/stanford-corenlp/stanford-corenlp-latest/stanford-corenlp-4.4.0/xom.jar:$CLASSPATH

# Stanford POS Tagger
export CLASSPATH=$HOME/software/stanford-postagger/stanford-postagger-2018-10-16/stanford-postagger.jar:$CLASSPATH
export CLASSPATH=$HOME/software/stanford-postagger/stanford-postagger-2018-10-16/stanford-postagger-3.9.2.jar:$CLASSPATH

# Stanford Parser
export CLASSPATH=$HOME/software/stanford-parser/stanford-parser-full-2018-10-17/stanford-parser.jar:$CLASSPATH
export CLASSPATH=$HOME/software/stanford-parser/stanford-parser-full-2018-10-17/stanford-parser-3.9.2-models.jar:$CLASSPATH
export CLASSPATH=$HOME/software/stanford-parser/stanford-parser-full-2018-10-17/ejml-0.23.jar:$CLASSPATH
export CLASSPATH=$HOME/software/stanford-parser/stanford-parser-full-2018-10-17/slf4j-api.jar:$CLASSPATH

# WordNet
export PATH=/usr/local/WordNet-3.0/bin:$PATH

# Golang
export GOPATH=$HOME/software/golang

