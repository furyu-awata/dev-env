# Setup fzf
# ---------
if [[ ! "$PATH" == */home/awatan/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/awatan/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/awatan/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/awatan/.fzf/shell/key-bindings.bash"
