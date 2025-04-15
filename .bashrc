# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

. /Systems/docker_setup.sh
export PATH=/home/ubuntu/.local/bin:$PATH
export GITHUB_TOKEN="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"
