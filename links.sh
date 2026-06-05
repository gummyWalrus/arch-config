#!/bin/bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
ln -s ~/.config/zsh/.zshrc ~/.zshrc
ln -s ~/.config/omz-themes/lanico.zsh-theme ~/.oh-my-zsh/themes/lanico.zsh-theme
ln -s ~/.config/gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
