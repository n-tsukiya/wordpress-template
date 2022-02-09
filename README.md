# WordPress の開発環境

## 概要
dockerにて、
- WordPressコンテナ
- DBコンテナ

上記２コンテナでの`WordPress`の開発環境構築の雛形のリポジトリ  
<br><br>


## プロジェクトの進め方
### 準備
#### リポジトリの再作成
```
git clone git@github.com:n-tsukiya/wordpress-template.git
mv wordpress-template [プロジェクト名]
```
ディレクトリ名を変更する  
`README.md`に関しては、「開発時」移行の文章は残しておいてドキュメントとして活用する  
<br>

```
cd [プロジェクト名]
rm -rf .git
```
で、本リポジトリのバージョン管理を削除、再度`git init`を行いプロジェクトとしてリポジトリを作成する  
<br>


#### .gitignoreの編集
```
db_data/*
```
`.gitignore`は上記の1行のみに修正(**他の行を削除する**)  
<br>


#### docker-compose.ymlの編集
`docker-compose.yml`の、
```
    environment:
      MYSQL_ROOT_PASSWORD: wordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
    # コンテナ名は変更すること
    container_name: wordpress_template_db

-- 中略 --

    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    # コンテナ名は変更すること
    container_name: wordpress_template_web
```
上記の`MYSQL_ROOT_PASSWORD`, `MYSQL_USER`, `MYSQL_PASSWORD`, `container_name`を変更する。  

それに合わせて`WORDPRESS_DB_USER`, `WORDPRESS_DB_PASSWORD`, `container_name`も修正する。  
<br>


#### WordPressの初期設定

```
docker-compose up -d
```
でコンテナ立ち上げ、`localhost:8080/`を確認して言語等の最低限の設定を行う  
この際に、
- html/配下にWordPressコアファイル
- db_data/配下にmysqlコアファイル

が作成される  
また、必要に応じて[別リポジトリ](https://github.com/n-tsukiya/wordpress-template)からブランクテーマを`html/wp-content/theme/`配下にダウンロードしておく  
<br>


### 開発時
#### 使用コマンド
```
docker-compose up -d
```
上記コマンドでコンテナ立ち上げ、`localhost:8080/`を確認、各種作業を行う  

<br>
終了時に

```
docker-compose down
```
上記コマンドでコンテナを落としておく  

立ち上げ直す際はまた`docker-compose up -d`を打ち込む  
<br>


#### DBのバックアップ
```
docker-compose exec -T db mysqldump --no-tablespaces --single-transaction -u [DBユーザー名] --password='パスワード' wordpress > ./backup/$(date "+%Y-%m-%d-%H-%M").sql
```
上記コマンドで、`./backup`ディレクトリ内にダンプファイルが作成される（**カレントディレクトリに注意!**）  
このファイルも含めてコミットする  
<br>


#### DBのリストア
```
docker-compose exec -T db mysql -u [DBユーザー名] --password='パスワード' wordpress < ./backup/[バックアップファイル].sql
```
上記コマンドで、DBが復元される。（**同じくカレントディレクトリに注意!**）  
これら作業でチーム間のDBの差分を吸収する。  
<br><br>


## 補足
`html/wp-config.php`内に下記を追記しておく  
```
define('WP_DEBUG', false);
// もしかしたら最初からfalseかも
```
これが`true`のままリリースしてしまうとサイト画面にエラー文字が出力されてしまう  
デバッグの際に使うかもしれないが、現状ほぼ使用していないためデフォルトで出力されないようにしておく  
<br><br>


## 各コンテナ概要
### WordPress コンテナ
ベースは`wordpress:php7.4-apache`とする（適宜更新予定）  
Dockerfile でイメージを作成、`php.ini`ファイルを書き換えて WP 管理画面からの上限を増やしてある。  
また、`.htaccess`もバインドマウントで上限を開放している。  
<br>


### DB コンテナ
素の`mysql:5.7`イメージを使用（バージョンを上げた方が良いかも？）  
<br>
