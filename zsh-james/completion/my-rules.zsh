setopt alwaystoend
setopt completeinword
setopt promptsubst

zstyle ':completion:*' menu select
zstyle '*' single-ignored show
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:*:*:users' ignored-patterns sshd 'nixbld*' nm-openvpn nm-iodine nobody system-network sddm messagebus polkituser rtkit
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion::complete:*' cache-path "$HOME/.cache/zsh-completion"
