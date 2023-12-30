# firebaseサンプル機能実装
iOSアプリでfirebaseで実装できる機能のサンプルコード集

## 1. Firebase プロジェクトを作成
[Firebase プロジェクト](https://console.firebase.google.com/?hl=ja&_gl=1*6fdmre*_ga*MTU1ODE0OTQ2Ni4xNzAzNDcyOTg5*_ga_CW55HF8NVT*MTcwMzgxNTAyNy4xMC4xLjE3MDM4MTUyMTIuNDYuMC4w)



## 2. 「iOS+」から iOS アプリを登録する
Apple Bundle ID を入力

GoogleService-Info.plist をダウンロード



## 3. Xcode で SDK のインストール
SPM パッケージURL：　https://github.com/firebase/firebase-ios-sdk

Up to Next Major Version で「Add Package」



## 4. アプリで Firebase を初期化する
AppDelegate に
```
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
```

application(\_:didFinishLaunchingWithOptions:)に
```
FirebaseApp.configure()
```



## 6. Authentication を開始する
[Sign-in method] タブで [メール / パスワード] を有効にして、[保存]
