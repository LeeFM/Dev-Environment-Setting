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

```shell
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

# 歷史記錄位置
~/.zsh_history
```

#### Tools

* Markdown 編輯器 - [HackMD](https://hackmd.io) , [Dillinger](https://dillinger.io)

* Terminal -  [iTerm](https://www.iterm2.com/) ＋ [oh-my-zsh](http://ohmyz.sh/)

* others -   [SourceTree](https://www.sourcetreeapp.com/)  ,  [Fork](https://git-fork.com/) ,  [Postman](https://www.getpostman.com/) ,  [The Unarchiver](https://theunarchiver.com/) ,   [Open In Terminal](https://github.com/Ji4n1ng/OpenInTerminal) ,  [Go2Shell](https://apps.apple.com/tw/app/go2shell/id445770608?mt=12) , [Sublime Text](https://www.sublimetext.com) , [DB SQLite](https://sqlitebrowser.org)

* 抓包工具 - [Proxyman](https://proxyman.io) , [Wireshark](https://www.wireshark.org)

* 心智圖 - [MindNode](https://mindnode.com) , [Xmind](https://www.xmind.net)

* 通訊軟體 - [Telegram](https://telegram.org) , [Slack](https://slack.com/intl/en-tw/) ,  [Franz](https://meetfranz.com)

* Debug - [FLEX](https://github.com/Flipboard/FLEX) , [simsim](https://github.com/dsmelov/simsim)

* UML - [OmniGraffle](https://www.omnigroup.com/omnigraffle/), [Drafter](https://github.com/L-Zephyr/Drafter), [swift-auto-diagram](https://github.com/yoshimkd/swift-auto-diagram), [draw.io](https://www.draw.io)

* 螢幕擷取工具 - [Xnip](https://apps.apple.com/tw/app/xnip-screenshot-annotation/id1221250572?mt=12) , [Snip](https://snip.qq.com)

* 改鍵工具 - [Karabiner](https://karabiner-elements.pqrs.org)

* HTML Debug工具 - [jsfiddle](https://jsfiddle.net)

* PushNotification測試工具 - [PushNotifications](https://github.com/onmyway133/PushNotifications/releases/tag/1.7.7)

* QuickLook- add QuickLook file to

  ```
  ~/Library/QuickLook/
  ```


#### 常用指令

```swift
// 修改pods
pod "MILib", :path => "../MILib"

pod "TradeFoundation", :git => "git@gitlab01.mitake.com.tw:RD1/TradeFoundation.git", :branch => '問題/92868_期貨下單畫面流動性風險欄位跑版'

// Xcode default version
sudo xcode-select --switch /Applications/Xcode10.3.app

// 刪除tags
git tag -l | xargs git tag -d

// 刪除Xcode模擬器
xcrun simctl erase all
```

#### Shortcuts

* 搜尋：**<u>cmd + shift + F</u>**  、 **<u>cmd+shift+O</u>**

* 文件變數方法縮圖：**<u>ctl + 6</u>**

* File搜尋：<u>**cmd + 1 >> cmd + opt +j**</u>

* Debug area：**<u>cmd + shift + Y</u>**

* 兩側：**<u>cmd + 0</u>** 、**<u>cmd + shift + 0</u>**
