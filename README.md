# iOSDC Japan 2018「プッシュ通知はどのような 進化をたどってきたか」サンプルコード

https://fortee.jp/iosdc-japan-2018/proposal/48329936-3058-4d73-a18c-9e163a5a229e

## Push 通知の送信テストスクリプトについて

`./sendpush` ディレクトリに簡単なスクリプトを置いています。

### 準備

Goで作っているので、環境がない場合は用意してください。  
https://golang.org/doc/install

依存ライブラリがあるため、以下のコマンドでgo getが必要です。

```
$ go get -u github.com/sideshow/apns2
```

APNs Keyで送信します。  
https://developer.apple.com/account/ios/authkey/ から "Apple Push Notifications service (APNs)" を選択してキーを作成し、.p8ファイルを `./sendpush` ディレクトリ直下に置いてください。

```
.
└── sendpush
    ├── AuthKey_XXXXXXXXXX.p8
    └── main.go
```

### 使い方

以下のように、必要な情報を環境変数で渡すことで実行できます。  

- `APN_AUTH_KEY_FILE` : .p8ファイルのファイル名
- `APN_KEY_ID` : KEY ID
- `APN_TEAM_ID` : TEAM ID
- `DEVICE_TOKEN` : アプリのデバイストークン

KEY IDは https://developer.apple.com/account/ios/authkey/ から、  
TEAM IDは https://developer.apple.com/account/#/membership/ などから確認できます。

```
$ APN_AUTH_KEY_FILE=AuthKey_XXXXXXXXXX.p8 APN_KEY_ID=XXXXXXXXXX APN_TEAM_ID=XXXXXXXXXX DEVICE_TOKEN=xxxxxxxxxx go run main.go
```

### ペイロードのサンプル

以下のケースのサンプルをmain.goに書いています。  
雑にコメントアウトで切り替える形にしています :bow:  
categoryなどはアプリのコードと対応しています。

- 本文のみ
- サイレントプッシュ通知
- カスタムアクション (categoryの指定)
- title, subtitleの指定
- Notification Content Extension用
- Notification Service Extension用
- スレッドIDの指定
