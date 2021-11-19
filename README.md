# super-ultra-scripts
## Misc Notes

###### Open SSL Installation
The [Git for Windows](https://gitforwindows.org/) installation includes OpenSSL; to call it within command prompt or PowerShell, we can add that location to the PATH environment variable. 

1. Adding the Git for Windows Bin directory to Windows PATH
 - `$env:Path += ";C:\Program Files\Git\usr\bin\"`
2. Close/Reopen CMD Prompt or PowerShell
3. Type openssl and press Enter; this should no longer produce an error message


#### WSL

##### Ubuntu Configuration

1. Install [zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH) / [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
2. Install powerlevel9k plugin
 - `git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k`
3. Install [Powerline fonts](http://iamnotmyself.com/2017/04/15/setting-up-powerline-shell-on-windows-subsystem-for-linux/) using PowerShell
 ```
 git clone https://github.com/powerline/fonts.git
 cd fonts
 ./install.ps1
 cd ..;rm -r -for ./fonts
 ```
4. Note: Will have to confirm installation as the script runs
5. Click the Ubuntu icon in the top left corner > properties > Font > Deja Vu Sans Mono for Powerline (18 point)
6. Edit the .zshrc file to configure plugins
 - `vim ~/.zshrc`
7. At the time of writing I am only using:
 - `plugins=(git)`
8. Configure git
 - `git config --global credential.helper store`
9. Syntax highlighting (confirm this works?)
```wget https://github.com/trapd00r/zsh-syntax-highlighting-filetypes/blob/master/zsh-syntax-highlighting-filetypes.zsh
mv zsh-syntax-highlighting-filetypes.zsh zsh-syntax-highlighting-filetypes.plugin.zsh
cd ~
 wget https://raw.github.com/trapd00r/LS_COLORS/master/LS_COLORS -O $HOME/.dircolors
echo 'eval $(dircolors -b $HOME/.dircolors)' >> $HOME/.zshrc
. $HOME/.zshrc
source .zshrc
```
10. Install [PowerShell on Ubuntu](https://docs.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.2)
```
# Update the list of packages
sudo apt-get update
# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common
# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
# Update the list of packages after we added packages.microsoft.com
sudo apt-get update
# Install PowerShell
sudo apt-get install -y powershell
# Start PowerShell
pwsh
``` 
##### Troubleshooting
###### pyenv not honoring version of python specified

* [Source](https://stackoverflow.com/questions/68345938/pyenv-does-not-use-correct-python-version)
* Add the following to ~/.bashrc:

```
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
#if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
```