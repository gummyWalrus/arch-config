#!/bin/bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
ln -s $PWD/zsh/.zshrc ~/.zshrc
ln -s $PWD/omz-themes/lanico.zsh-theme ~/.oh-my-zsh/themes/lanico.zsh-theme
ln -s $PWD/gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
