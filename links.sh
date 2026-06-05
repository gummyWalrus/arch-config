#!/bin/bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
ln -s zsh/.zshrc ~/.zshrc
ln -s omz-themes/lanico.zsh-theme ~/.oh-my-zsh/themes/lanico.zsh-theme
ln -s gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
