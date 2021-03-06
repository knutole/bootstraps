#!/bin/sh
#
# install zsh + powerlevel10k + plugins on 
# os: amazon linux 2 
# v. 21.03.06 
# 
# √ tested
# 

# install zsh
sudo yum update && sudo yum -y install zsh git wget

# install oh-my-zsh
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh --output ~/install-oh-my-zsh.sh
sh ~/install-oh-my-zsh.sh --unattended
rm ~/install-oh-my-zsh.sh 

# install powerlevel10k theme in oh-my-zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/ec2-user/.oh-my-zsh/themes/powerlevel10k

# install zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone --depth=1 https://github.com/johanhaleby/kubetail.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/kubetail

# get zsh config
curl https://raw.githubusercontent.com/knutole/bootstraps/main/bootstrap-scripts/.zshrc.template -H "Cache-Control: no-cache"  -L > ~/.zshrc

# get powerlevel10k config
curl https://raw.githubusercontent.com/knutole/bootstraps/main/bootstrap-scripts/.p10k.zsh.template -H "Cache-Control: no-cache"  -L > ~/.p10k.zsh

# set as default
sudo usermod --shell /bin/zsh ec2-user

# activate
exec zsh
