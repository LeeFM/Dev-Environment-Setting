#!/bin/bash
#2019年 6月21日 週五 14時11分20秒 CST
echo  Set up qaCheck.sh
read -n1 -p "任意鍵開始" doit

setup () {
read -p "請輸入券商PID:" id
DIR="$(cd "$(dirname "$0")" && pwd)"
echo $DIR
cd $DIR/TouchStock_$id
updateDate
plistCheckKey
versionCheck
}


# 更新TSInfo.plist 至當下日期
updateDate () {
  target="TSInfo.plist"

  phone="I"$id"20"$(date +%y%m%d)"000010"
  pad="I"$id"20$(date +%y%m%d)000011"

  plutil -replace TSInnerVersion -string $phone $target
  plutil -replace TSInnerVersion~Pad -string $pad $target
}

# 檢查目前已知保留項，沒有會直接新增，有會直接替換
plistCheckKey () {
  plist=("Info.plist" "Info_InHouse_iPhone.plist" "Info_InHouse_iPad.plist" "Info_Release_iPhone.plist" "Info_Release_iPad.plist" "Info_InHouse_Universal.plist" "Info_Release_Universal.plist")
  # 更新 changeFullScreen true，此選項false可能會造成Release被擋
  plutil -replace UIRequiresFullScreen -bool "true" $plist 
  # 6/12更新 此選項可能會造成iOS12開啟指紋閃退
  plutil -replace NSFaceIDUsageDescription -string "是否允許\$(PRODUCT_NAME)使用臉部辨識功能,以進行驗證功能？" $plist 
  plutil -replace NSLocationAlwaysAndWhenInUseUsageDescription -string "是否允許\$(PRODUCT_NAME)通過您的地理位置信息獲取您周邊的相關數據,以利分公司尋找" $plist
  plutil -replace NSLocationWhenInUseUsageDescription -string "是否允許\$(PRODUCT_NAME)通過您的地理位置信息獲取您周邊的相關數據,以利分公司尋找" $plist
  plutil -replace NSLocationAlwaysUsageDescription -string "是否允許\$(PRODUCT_NAME)通過您的地理位置信息獲取您周邊的相關數據,以利分公司尋找" $plist
  plutil -replace NSPhotoLibraryUsageDescription -string "是否允許\$(PRODUCT_NAME)訪問你的媒體資料庫,以利存取圖片？" $plist
  plutil -replace NSCameraUsageDescription -string "是否允許\$(PRODUCT_NAME)使用你的相機，以利拍照上傳？" $plist
  plutil -replace NSPhotoLibraryUsageDescription -string "是否允許\$(PRODUCT_NAME)訪問你的媒體資料庫？" $plist
}

# 修改版號
versionCheck (){
	read -p "Version 指定大版號四碼" Version
	read -p "Inner verison 指定小版號" Inner

changeplist
  #目前只有富邦有，但對其他家不影響
  cd "Supporting Files"
  changeplist
  cd $DIR/TouchStock_$id\ WatchOS2
  changeplist
  cd -
  cd $DIR/TouchStock_$id\ WatchOS2\ Extension/
  changeplist
  cd -
  cd $DIR/TouchStock_$id\ WatchKit\ App/
  changeplist
  cd -
  cd $DIR/TouchStock_$id\ WatchKit\ Extension/
  changeplist
}

# plist更新版號項目
changeplist () {
  plist=("Info.plist" "Info_InHouse_iPhone.plist" "Info_InHouse_iPad.plist" "Info_Release_iPhone.plist" "Info_Release_iPad.plist" "Info_InHouse_Universal.plist" "Info_Release_Universal.plist")

  for i in "${plist[@]}"
  do
    plutil -replace CFBundleVersion -string $Version $i
    plutil -replace CFBundleShortVersionString -string $Inner $i
  done
}

case $doit in
  1) setup;;
  *) setup ??;;
esac
