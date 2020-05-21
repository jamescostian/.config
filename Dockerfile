FROM ubuntu:latest

# Install my config
COPY setup.sh /
COPY scripts-james/helpers/install-if-not-exists /
COPY . /root/.config/cloned-config-james
RUN ./setup.sh

# Actually use my zsh config (which will cause the rest of my config to be used)
ENV ZDOTDIR="/root/.config/zsh-james"

# Install zplug things by having zsh start up once.
# Some zplugin things only get activated on "lucid", hence "--interactive"
# In order to keep the interactiveness alive, you need to send commands, ideally ones with a 0 exit status, like true
# That's why I use "yes true".
# But you also need to kill the process (hence the timeout)
RUN yes true | timeout -s KILL 60 zsh --interactive 2> /dev/null || true

CMD /bin/zsh
