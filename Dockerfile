FROM alpine:edge

# Install my config
RUN sh -c 'eval "$(wget -qO - https://jami.am)"'

# Actually use my zsh config (which will cause the rest of my config to be used)
ENV ZDOTDIR="/root/.config/zsh-james"

# Install zplug things by having zsh start up once.
# Some zplugin things only get activated on "lucid", hence "--interactive"
# In order to keep the interactiveness alive, you need to send commands, ideally ones with a 0 exit status, like true
# That's why I use "yes true".
# But you also need to kill the process (hence the timeout)
RUN yes true | timeout -s KILL 40 zsh --interactive 2> /dev/null || true

CMD /bin/zsh
