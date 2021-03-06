#!/bin/sh
#
# install zsh + powerlevel10k + plugins on amazon linux 2 
# v. 21.03.01 
# 
# √ tested
# 

# install zsh
sudo yum update && sudo yum -y install zsh git wget

# install oh-my-zsh
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh --output ~/install-oh-my-zsh.sh
sh ~/install-oh-my-zsh.sh --unattended

# install powerlevel10k theme in oh-my-zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/ec2-user/.oh-my-zsh/themes/powerlevel10k

# install zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git /home/ec2-user/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# get & overwrite zsh config
curl https://raw.githubusercontent.com/mapic/k8-experiments/main/.zshrc -H "Cache-Control: no-cache"  -L > ~/.zshrc

# get powerlevel10k config
curl https://raw.githubusercontent.com/mapic/k8-experiments/main/.p10k.zsh -H "Cache-Control: no-cache"  -L > ~/.p10k.zsh

# set as default
sudo usermod --shell /bin/zsh ec2-user

# cleanup
rm ~/install-oh-my-zsh.sh 

# activate
exec zsh
