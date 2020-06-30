# てくもく

Ruby on Railsの学習のアウトプットとして作成したポートフォリオになります。

プログラミング学習者同士がイベントや勉強会、もくもく会などのコミュニティを通して切磋琢磨できるアプリケーションを作成しました。

## URL

https://www.tech-moku.work

## 使用技術

#### バックエンド
* Ruby 2.5.1
* Ruby on Rails 5.2.1
* MySQL8.0.15
#### フロントエンド
* HTML (Slim)
* CSS (SCSS)
* JavaScript
* JQuery
* BootStrap 4.3
#### インフラ
##### AWS
* VPC
* EC2
* RDS
* Route53
* S3
* ALB
* ACM

#### Web,APサーバー
* Nginx
* Unicorn

## ER図
![erd](https://user-images.githubusercontent.com/52910621/86078704-a05f1480-bac9-11ea-9798-56525e5f9458.png)

## 機能一覧

#### イベント

* イベント主催
  - GeoCoder(Google Map API)を用いた地図検索機能
  - Geocoder gem を用いたアドレスから緯度経度の取得
  - Form Objectを用いたイベントと開催場所の紐付け
  - Tagをスペース区切りで登録
* 一覧表示
  - kaminariを用いたページネーション機能
  - ブックマーク登録機能
  - キーワード検索機能
  - Tag検索機能
* 詳細ページ表示
  - Google Map APIを用いた地図表示
* イベント編集
* イベント削除
* コメント投稿機能（Ajax)
  - 無限スクロールを用いたコメント一覧表示
  - 返信コメント表示
  - 新規コメント投稿
  - コメントに対する返信コメント投稿

#### ダイレクトメッセージ機能
  - チャットルーム作成
  - チャットルーム一覧表示
  - メッセージ送信
  - メッセージ削除
  
#### 通知機能
  - イベントをブックマークした際にイベントの主催者に通知送信
  - イベントに対してコメントした際にイベントの主催者と他のコメントしたユーザーに通知送信
  - 他ユーザーにダイレクトメッセージを送った際に対象ユーザーに通知送信
  - 他ユーザーをフォローした際に対象ユーザーに通知送信

#### ユーザー

* 一覧表示
  - Active Strageを用いたプロフィール画像アップロード機能
* ユーザー一覧表示
  - 無限スクロール
* ユーザー詳細ページ
  - ユーザーが主催するイベント一覧表示
  - ユーザーが参加するイベント一覧表示
  - ブックマークしたイベント一覧表示
  - お知らせ(通知)一覧表示（未確認の通知に関してはNewタグを付与）
* ユーザープロフィール更新
* 退会機能
* フォローフォロワー機能
  - 他ユーザーのフォロー/フォロー解除機能
  - フォローユーザーの一覧表示
  - フォロワーユーザーの一覧表示

#### イベントへの参加

* イベント参加
* 参加したイベントのキャンセル

#### セッション(Bcrypt)

* ログイン
* 簡単ログイン
* ログアウト
