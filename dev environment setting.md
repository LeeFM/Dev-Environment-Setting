#### Xcode file directory

```objective-c
// Templates
mkdir -p ~/Library/Developer/Xcode/Templates/File\ Templates/Custom

// CodeSnippets
~/Library/Developer/Xcode/UserData/CodeSnippets
```

#### [Homebrew](https://brew.sh/)

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

#### [Git](https://git-scm.com/)

```
brew install git
```

#### [CocoaPods](https://cocoapods.org/)

```
gem install cocoapods 
pod setup
```

#### git alias

```
[alias]
	st = status
	br = branch
	ch = checkout
	co = commit
	di = difftool
	me = mergetool
	tree = log --graph --pretty=oneline --abbrev-commit
```

#### .vimrc

```
syntax on
set ai
set shiftwidth=4
set ruler
set backspace=2
set ic
set hlsearch
set incsearch
set smartindent
set confirm
set history=200
set cursorline
set number
set mouse=a
set selection=exclusive
set selection=mouse,key
set t_Co=256
set showmatch
set tabstop=4
set autoindent
set paste
set laststatus=2
```

#### zsh autocomplete

```sh
cd ~/.oh-my-zsh/custom/plugins/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions.git
vi ~/.zshrc
在文件中找 plugins=(git)
添加zsh-autosuggestions變成
plugins=(
	git
	zsh-autosuggestions
)
source ~/.zshrc  
```

#### Tools

* Markdown 編輯器 -  [Typora](https://typora.io/)

* Terminal -  [iTerm](https://www.iterm2.com/) ＋ [oh-my-zsh](http://ohmyz.sh/) 

* others -   [SourceTree](https://www.sourcetreeapp.com/)  ,  [Fork](https://git-fork.com/) ,  [Postman](https://www.getpostman.com/) ,  [The Unarchiver](https://theunarchiver.com/) ,   [Open In Terminal](https://github.com/Ji4n1ng/OpenInTerminal) ,  [Go2Shell](https://apps.apple.com/tw/app/go2shell/id445770608?mt=12)

* 通訊軟體 -  [Franz](https://meetfranz.com)

* Debug - [FLEX](https://github.com/Flipboard/FLEX) , [simsim](https://github.com/dsmelov/simsim)

* UML - [OmniGraffle](https://www.omnigroup.com/omnigraffle/)

* QuickLook- add QuickLook file to 

  ```
  ~/Library/QuickLook/
  ```


#### 常用指令

```swift
// FLEX
[[FLEXManager sharedManager] showExplorer];

#ifdef DEBUG
#import "FLEXManager.h"
#endif

pod 'FLEX', :configurations => ['Debug']

// 修改pods
pod "MILib", :path => "../MILib"

pod "TradeFoundation", :git => "git@gitlab01.mitake.com.tw:RD1/TradeFoundation.git", :branch => '問題/92868_期貨下單畫面流動性風險欄位跑版'

// Xcode default version
sudo xcode-select --switch /Applications/Xcode10.3.app

// 刪除tags
git tag -l | xargs git tag -d 
```

#### Shortcuts

* 搜尋：**<u>cmd + shift + F</u>**  、 **<u>cmd+shift+O</u>**

* 文件變數方法縮圖：**<u>ctl + 6</u>**

* File搜尋：<u>**cmd + 1 >> cmd + opt +j**</u>

* IDE縮放：**<u>單視窗 cmd + enter</u>** ； **<u>雙視窗 cmd + opt + enter</u>** 、 **<u>ctl + opt + cmd + enter (Xcode 11)</u>**

* Debug area：**<u>cmd + shift + Y</u>**

* 兩側：**<u>cmd + 0</u>** 、**<u>cmd + shift + 0</u>** 

