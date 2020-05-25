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
* BootStrap 4.4
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

## 機能一覧

#### イベント

* イベント主催
  - GeoCoder(Google Map API)を用いた地図検索機能
  - Geocoder gem を用いたアドレスから緯度経度の取得
  - Form Objectを用いたイベントと開催場所の紐付け
* 一覧表示
  - kaminariを用いたページネーション機能
  - ransackを用いたキーワード検索機能
* 詳細ページ表示
  - Google Map APIを用いた地図表示
* イベント編集
* イベント削除

#### ユーザー

* ユーザー登録
  - Active Strageを用いたプロフィール画像アップロード機能
* ユーザー一覧表示
  - kaminariを用いたページネーション
* ユーザー詳細ページ
  - ユーザーが主催するイベントの表示
  - ユーザーが参加するイベントの表示
* ユーザープロフィール更新

#### イベントへの参加

* イベント参加
* 参加したイベントのキャンセル

#### セッション(Bcrypt)

* ログイン
* 簡単ログイン
* ログアウト

## 今後追加したい機能
* ユーザー同士のチャット機能
* イベントメンバー限定のチャットルーム
* お気に入り機能
* フォロー機能
