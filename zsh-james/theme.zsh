PROMPT_GEOMETRY_GIT_TIME="false"
PROMPT_GEOMETRY_GIT_CONFLICTS="true"
GEOMETRY_GIT_SEPARATOR=" "
GEOMETRY_SYMBOL_GIT_CLEAN="⬡"
GEOMETRY_SYMBOL_GIT_BARE="⬡"
GEOMETRY_SYMBOL_GIT_DIRTY="⬢"
GEOMETRY_PATH_COLOR=5
GEOMETRY_GIT_NO_COMMITS_MESSAGE="❄new❄ "
# Enable iterm2 marks
GEOMETRY_STATUS_SYMBOL="▲%{$(iterm2_prompt_mark)%}"
GEOMETRY_STATUS_SYMBOL_ERROR="△%{$(iterm2_prompt_mark)%}"


PS1="$ " # Temporary prompt until the real one has loaded
zinit ice from"gh" lucid
zinit light geometry-zsh/geometry
GEOMETRY_STATUS_COLOR=$(geometry::hostcolor)
