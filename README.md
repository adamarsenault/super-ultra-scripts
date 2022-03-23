# super-ultra-scripts
## Mac Configuration

### Setup 
Eventually will script out, recording here for now.

1. Install ohmyzsh:
   - `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
3. Install homebrew:
   - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
4. Install casks:
   - `brew install --cask visual-studio-code firefox dbeaver-community iterm2 spotify`
5. Install formulae
   - `brew install --formulae tmux pyenv pyenv-virtualenv`
6. Install AWS CLI
   - `curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"\nsudo installer -pkg AWSCLIV2.pkg -target`
7. Enable synatax highlighting in vim
   - `echo "synxtax on" > ~/.vimrc`

####  Zsh Configuration

1. Install zsh-autosuggestions:
   - `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`
2. Install Powerline fonts:
     ```
      # clone
      git clone https://github.com/powerline/fonts.git --depth=1
      # install
      cd fonts
      ./install.sh
      # clean-up a bit
      cd ..
      rm -rf fonts```
3. Edit .zshrc with configurations:
   - Update Autosuggest highlight color when using Solarized color theme:
      - `echo "ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=23'" >> ~/.zshrc` 
   - pyenv configuration:
    ```
    tee -a ~/.zshrc << END
    # pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/shims:$PATH"
    if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
    #if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi    
    END
    ```
   - Enable plugins / set profile
     - ZSH_THEME="agnoster"
     - plugins=(colorize colored-man-pages copyfile git jsontools zsh-autosuggestions)
4. iTerm2 settings with agnoster theme:
   - Colors: Solarized (Dark)
   - Font: DejaVu Sans Mono for Powerline

#### Misc
1. Download the following from the Apple Store:
   - BetterSnapTool
   - Pasta: https://getpasta.com/

### Git Foo
Delete local branches that have been merged:
* Linux: 
    * `git branch --merged | egrep -v "(^\*|master|main|dev|test|prod)" | xargs git branch -d`

## Windows Configuration

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

### Git Foo
##### Commands

Delete local branches that have been merged:

* Powershell:
  * `git branch --merged | %{$_.trim()}  | ?{$_ -notmatch 'dev' -and $_ -notmatch 'master' -and $_ -notmatch 'main'} | %{git branch -d $_}`
