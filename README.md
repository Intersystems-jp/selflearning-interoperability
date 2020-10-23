# Interoperability（相互運用性）を使ってみよう
このGitでは、InterSystems IRIS ／ InterSystems IRIS for Health の Interoperability メニューの使い方をサンプルを利用しながら確認できるコンテナを提供しています。
このサンプルのコンテナは、[InterSystems IRIS Community Editionのイメージ](https://hub.docker.com/_/intersystems-iris-data-platform)を使用しています（Pullできない場合はイメージ、タグ名をご確認ください）。
[Intersystems IRIS for Health の Community Edition のイメージ](https://hub.docker.com/_/intersystems-iris-for-health)もあります。お好みでイメージを切り替えてご利用ください。

この他、JDBCでの接続が行えるように OpenJDK もインストールしています。
詳細は、[Dockerfile](./Dockerfile) をご参照ください。


## [コミュニティ](https://jp.community.intersystems.com)にサンプルについての解説を記述しています。
索引ページ：https://jp.community.intersystems.com/node/483021



## ディレクトリ／サンプルファイルについて
サンプルファイルについて詳細は以下の通りです。

|種別|ファイル|説明|
|:--|:--|:--|
|ビジネス・サービス|[FileBS.cls](/src/Start/FileBs.cls)|ファイルインバウンドアダプタを利用したビジネス・サービスクラス|
|ビジネス・サービス|[WebServiceBS.cls](/src/Start/WS/WebServiceBS.cls)|Webサービス用のビジネス・サービスクラス|
|ビジネス・サービス|[NonAdapterBS.cls](/src/Start/NonAdapterBS.cls)|アダプタを使用しないビジネス・サービスクラス（ストアドプロシージャ／RESTから呼び出すときに使用する）|
|ビジネス・プロセス|[WeatherCheckProcess.cls](/src/Start/WeatherCheckProcess.cls)|お天気APIとデータベースの更新処理を順序を守って実行するビジネス・プロセスクラス|
|ビジネス・オペレーション|[GetKionOperation.cls](/src/Start/GetKionOperation.cls)|お天気APIにアクセスして指定する都市の天気情報を取得するビジネス・オペレーションクラス|
|ビジネス・オペレーション|[InsertOperation.cls](/src/Start/InsertOperation.cls)|IRIS内データベースにINSERTを実行するビジネス・オペレーションクラス（コンテナ開始時このクラスを利用しています）|
|ビジネス・オペレーション|[SQLInsertOperation.cls](/src/Start/SQLInsertOperation.cls)|SQLアウトバウンドアダプタを利用したビジネス・オペレーションクラス（コンテナ開始時JDBCで接続できるように設定されています）|
|メッセージ|[Request.cls](/src/Start/Request.cls)|プロダクション内で使用する要求（リクエスト）メッセージクラス|
|メッセージ|[Response.cls](/src/Start/Response.cls)|プロダクション内で使用する応答（レスポンス）メッセージクラス|
|プロダクション|[Production.cls](/src/Start/Production.cls)|管理ポータルで設定する定義を保存しているプロダクション用クラス（このクラスの修正は管理ポータルで行います）|
|データ登録用クラス|[WeatherHistory.cls](/src/Start/WeatherHistory.cls)|データ登録用クラス（テーブル）で取得した天気の情報と購入商品名を登録するテーブル|
|インストーラー用クラス|[Installer.cls](/src/Installer.cls)|コンテナビルド時に初期実行する内容を含めたインストーラークラス　メモ：[インストーラーについて](https://docs.intersystems.com/iris20201/csp/docbookj/DocBook.UI.Page.cls?KEY=GCI_manifest)|


## コンテナ起動までの手順
詳細は、[docker-compose.yml](./docker-compose.yml) をご参照ください。

Git展開後、**./ は コンテナ内 /irisdev/app ディレクトリをマウントしています。**
また、IRISの管理ポータルの起動に使用するWebサーバポートは 52773 が割り当てられています。

```
git clone このGitのURL
```
cloneしたディレクトリに移動後、以下実行します。

```
$ docker-compose build
```
ビルド後、コンテナを開始します。
```
$ docker-compose up -d
```
コンテナを停止する方法は以下の通りです。
```
$ docker-compose stop
```

## プロダクションのデータを送信してみる
コンテナ開始後、以下のURLにアクセスします。ユーザ名（_system）とパスワード（SYS）を指定してログインします。
http://localhost:52773/csp/sys/UtilHome.csp

管理ポータル > [Interoperability] > [構成] > [プロダクション] を開きます。

（コンテナ作成時にプロダクション：Start.Production を自動起動する設定としているためプロダクションは開始しています）

また、コンテナ作成時に REST 用のベース URL（/start）が設定されています。
以下URLにアクセスしてプロダクションにデータを送信します。
例）
http://localhost:52773/start/weather/ちくわ/豊橋市

正しく情報が送信できると、以下の文字列が表示されます。
{"Message":"天気情報確認：依頼しました","Status":1}

天気を取得し、データベースに登録できているかどうかは、メッセージの参照とStart.WeatherHistoryテーブルを参照して確認します。

メッセージの確認：
管理ポータル > [Interoperability] > [表示] > [メッセージ] を開き「ソース」欄に「Start.NonAdapterBS」が表示されている行を探し、セッション番号をクリックしてトレースを確認します。

テーブルデータの確認：
管理ポータル > [システムエクスプローラ] > [SQL] > ネームスぺースUSERに変更 > スキーマ：Start > テーブル：WeatherHistory > 画面右端「テーブルを開く」クリック