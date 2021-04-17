#!/bin/bash

ZSH_VERSION=$(zsh --version)

echo "ZSH: $ZSH_VERSION"
echo "HOME: $HOME"

# install oh-my-zsh
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh --output $HOME/install-oh-my-zsh.sh
sh $HOME/install-oh-my-zsh.sh --unattended
rm $HOME/install-oh-my-zsh.sh 

# install powerlevel10k theme in oh-my-zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/themes/powerlevel10k

# install zsh plugins
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone --depth=1 https://github.com/johanhaleby/kubetail.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/kubetail

# get & overwrite zsh config
curl https://raw.githubusercontent.com/knutole/bootstraps/main/zsh/.zshrc.template -H "Cache-Control: no-cache"  -L > $HOME/.zshrc

# get powerlevel10k config
curl https://raw.githubusercontent.com/knutole/bootstraps/main/zsh/.p10k.zsh.template -H "Cache-Control: no-cache"  -L > $HOME/.p10k.zsh

# set zsh as default shell
sudo chsh -s /bin/zsh ubuntu

# refresh
exec zsh 

echo "All done!"

