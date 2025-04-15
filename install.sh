#!/bin/bash

# Get the relative path to the script.
if [[ "${OS}" == "Windows_NT" ]] || [[ "${OSTYPE}" == "darwin"* ]] || [[ -n "${BASH}" ]]; then
    RELATIVE_PATH_TO_SCRIPT="$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")"
elif ! [ -z "${WSL_DISTRO_NAME}" ]; then
    # Added the string replacement to allow this file to be sourced and work if
    # sourcing it errors on $0 == "-bash".
    RELATIVE_PATH_TO_SCRIPT=$(dirname ${0//-})
    # Set sudo if running in WSL
    SUDO=sudo
else
    RELATIVE_PATH_TO_SCRIPT=$(dirname -- "${0}")
fi

if [ ! -z ${REPO_PATH+x} ]; then
    source ${REPO_PATH}/sim/utils/utils.sh
else
    printf "ERROR: path to repository root is not defined.\n"
    # printf "ERROR: please execute: source <repo root>/docker_setup.sh\n"
    # exit 1
    # Get the full path to the repo (or the worktree) root.
    REPO_PATH="$(cd ${RELATIVE_PATH_TO_SCRIPT} && pwd)"
    PATH="${REPO_PATH}/tools/utils:${PATH}"
    source sim/utils/utils.sh
fi

check_zsh_installed() {
    if command -v zsh &> /dev/null; then
        print_info "Zsh shell is installed."
        return 0
    else
        print_info "Zsh shell is not installed. Proceeding with installation."
        return 1
    fi
}

check_brew_installed() {
    if command -v brew &> /dev/null; then
        print_info "Homebrew is installed."
        return 0
    else
        print_info "Homebrew is not installed. Proceeding with installation."
        return 1
    fi
}

install_homebrew() {
    print_info "Installing Homebrew..."
    yes '' | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &> /dev/null
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}


install_zsh() {
    print_info "Installing zsh shell..."
    brew install zsh &> /dev/null
    if ! check_zsh_installed; then
        print_error "Failed to install zsh shell."
        return 1
    fi
    print_info "Setting zsh as the default shell..."
    echo $(which zsh) | sudo tee -a /etc/shells > /dev/null
    sudo chsh -s $(which zsh) $USER
    if [ "$?" != "0" ]; then
        print_error "Failed to set zsh as the default shell."
        return 1
    fi
}

install_starship() {
    print_info "Installing starship..."
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y > /dev/null
}

install_utils() {
    print_info "Installing some utilities..."
    sudo apt install -y ripgrep &> /dev/null
    brew install zsh-autosuggestions &> /dev/null
    brew install nano &> /dev/null
    brew install buildifier &> /dev/null
}

install_git() {
    # Check that the git version is above 2.4.0
    if ! check_git_version; then
        print_info "Installing git..."
        sudo apt-get remove -y git &> /dev/null
        brew install git &> /dev/null
        if ! check_git_version; then
            print_error "Failed to install git or git version is not above 2.4.0."
            return 1
        fi
        brew install git-lfs &> /dev/null
    fi
}

check_git_version() {
    local git_version=$(git --version | awk '{print $3}')
    local required_version="2.40.0"

    if [[ "$(printf '%s\n' "$required_version" "$git_version" | sort -V | head -n1)" == "$required_version" ]]; then
        print_info "Git version $git_version is above 2.4.0."
        return 0
    else
        return 1
    fi
}


install_revup() {
    print_info "Installing revup..."
    pip3 install revup &> /dev/null
    sudo apt-get update && sudo apt-get install -y man-db &> /dev/null
}

if ! check_brew_installed; then
    install_homebrew || { print_error "Failed to install Homebrew."; exit 1; }
fi

if ! check_zsh_installed; then
    install_zsh || { print_error "Failed to install zsh shell."; exit 1; }
    install_starship || { print_error "Failed to install starship."; exit 1; }
    install_utils || { print_error "Failed to install utilities."; exit 1; }
    install_git || { print_error "Failed to install git."; exit 1; }
    install_revup || { print_error "Failed to install revup."; exit 1; }
fi

ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.bash_aliases ~/.bash_aliases

print_info "Done!"