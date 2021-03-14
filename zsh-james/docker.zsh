export DOCKER_CONFIG="$HOME/.config/docker$MULTITENANT_SUFFIX"

# Use buildkit
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

# Aliases for docker, plus docker-compose and docker-machine aliases I'm not a fan of
zinit ice wait lucid
zinit snippet https://raw.githubusercontent.com/akarzim/zsh-docker-aliases/3b7f40ed1c47c4e47bd2a2846c236cf91603b8c7/alias.zsh
# Aliases for docker-compose
zinit ice wait lucid
zinit snippet OMZ::plugins/docker-compose/docker-compose.plugin.zsh
