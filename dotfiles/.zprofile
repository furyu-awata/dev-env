umask 022

# >>> coursier install directory >>>
export PATH="$PATH:/home/awatan/.local/share/coursier/bin"
# <<< coursier install directory <<<
if command -v mise 1>/dev/null 2>&1; then
	eval "$(mise activate zsh --shims)"
fi

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
