#Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
# DEL キー設定
bindkey '^[[3~' delete-char
# End of lines configured by zsh-newuser-install

# 先頭がスペースならヒストリーに追加しない。
setopt hist_ignore_space
# ベルを鳴らさない。
setopt no_beep
# 履歴の共有
setopt share_history
# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups
# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_dups
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
# 空白文字を単語の区切りとして解釈する
setopt sh_word_split
# C-s, C-qを無効にする。
setopt no_flow_control
# scpする際のワイルドカード展開を無効にする。
setopt nonomatch
# バックグラウンド処理の終了をターミナルに即時通知する
setopt notify
#stty start undef
#stty stop undef
# の替り
# コマンド行末のスラッシュを削除しない
unsetopt auto_remove_slash
# --prefix=/usr などの = 以降も補完
setopt magic_equal_subst
## 補完候補の色づけ
#eval `dircolors`
#export ZLS_COLORS=$LS_COLORS
## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
#setopt auto_param_slash
## {a-c} を a b c に展開する機能を使えるようにする
setopt brace_ccl
## cd 時に自動で push
setopt auto_pushd
### 同じディレクトリを pushd しない
setopt pushd_ignore_dups
## サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
#setopt auto_resume
# 補完候補一覧でファイルの種別をマーク表示
setopt list_types
## 出力の文字列末尾に改行コードが無い場合でも表示
#unsetopt promptcr
## コアダンプサイズを制限
#limit coredumpsize 102400

# zsh設定ファイルパスの追加
if [ -d ~/.zsh/zsh-completions ]; then
	fpath=(~/.zsh/zsh-completions/src ~/.zsh/prompt $fpath)
fi

# 補完関数の実行
autoload -U compinit
compinit

# 補完の時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補をカーソル選択
zstyle ':completion:*' menu select=1
# 補完候補に色付け
zstyle ':completion:*' list-colors di=34 fi=0

# PROMPT setting
## 色を使う
autoload promptinit
promptinit

# locale
unset LC_ALL
export LANG=ja_JP.utf8
export LESSCHARSET=UTF-8
export LESSOPEN='|/usr/share/source-highlight/src-hilite-lesspipe.sh %s'
export LESS='-M-x4$ -r -R'

export LS_OPTIONS="-F --color=auto"
alias	ls='/bin/ls ${LS_OPTIONS}'

# zipを直接実行する動作をした時のデフォルト設定
alias -s zip='unzip -O CP932'

for target in txt c cpp h ini conf java dicon xml
do
	alias -s ${target}=vim
done

export VI="vim"
export EDITOR="vim"

autoload zmv

# plugin
# zsh-completionsしか使用していないので。一旦これで
function plug_update() {
	if [ -d .zsh/zsh-completions ]; then
		pushd .zsh/zsh-completions
		git pull
	else
		pushd .zsh
		git clone https://github.com/zsh-users/zsh-completions.git
	fi
	popd
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.fzf-function.sh ] && source ~/.fzf-function.sh
if [ -d ~/.zsh/zsh-completions/src ]; then
	fpath=(~/.zsh/zsh-completions/src $fpath)
fi
source /usr/share/doc/fzf/examples/key-bindings.zsh

# mise
eval "$(mise activate zsh)"
export PATH="$HOME/.local/share/mise/shims:$PATH"
export MISE_DATA_DIR=$HOME/.mise
export MISE_CACHE_DIR=$MISE_DATA_DIR/cache
export MISE_USE_TOML=1

# direnv
# miseの初期化がプロンプト表示時なのでフルパス指定しないとコマンドが見つからない
if command -v ${HOME}/.mise/installs/direnv/latest/bin/direnv > /dev/null; then
	eval "$(${HOME}/.mise/installs/direnv/latest/bin/direnv hook zsh)"
fi

# github cli
# miseの初期化がプロンプト表示時なのでフルパス指定しないとコマンドが見つからない
if command -v ${HOME}/.mise/installs/github-cli/latest/bin/gh > /dev/null; then
        eval "$(${HOME}/.mise/installs/github-cli/latest/bin/gh completion -s zsh)"
fi
