# WordPress の開発環境

## 概要

docker にて、

- WordPress コンテナ
- DB コンテナ

上記２つのコンテナでの WordPress 環境の構築  
<br><br><br>

## 準備

```linuxコマンド
$ mkdir html
```

で、html/ディレクトリを作成する  
<br>

`docker-compose.yml`の 15 行目、33 行目の

```yml
container_name: wordpress_template_web
---
container_name: wordpress_template_db
```

は記述を変更してどのコンテナか分かりやすくしておくこと  
<br>  
また、テンプレート目的でのリポジトリ管理なので、

```linuxコマンド
$ rm -rf .git/ .gitignore
```

で、バージョン管理は削除しておく（案件でバージョン管理を行いたいなら再度`git init`を行う）

<br><br><br>

## 使い方

```linuxコマンド
$ docker-compose up -d
```

上記コマンドを叩いて、`localhost:8080/`を確認  
WP の初期設定を行う  
html/配下に WP の各種ファイルが作成される
<br>  
そして、

```linuxコマンド
$  cp ./config/.htaccess ./html/
```

で、.htaccess を取り替えておく  
これで WP Mingration による復元等をスムーズに行える  
<br>  
終了時に

```linuxコマンド
$ docker-compose down
```

で、落としておく  
立ち上げ直す際はまた`up -d`をする  
以上。
<br><br><br>

## WordPress コンテナ

ベースは`wordpress:php7.4-apache`とする（適宜更新予定）  
Dockerfile でイメージを作成、`php.ini`ファイルを書き換えて WP 管理画面からの上限を増やしてある

<br><br><br>

## DB コンテナ

特に変哲のない`mysql:5.7`イメージを使用（バージョンを上げた方が良いかも？）
