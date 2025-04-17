### 合言葉を使用した無料の写真共有サービスです。

合言葉を使用して秘密の写真を投稿、共有します。

Versions

- Ruby: 3.2.2
- Rails: ~> 8.0

## docker のセットアップ

```
# 最初のセットアップ
docker compose build

# seedデータの投入
docker compose run --rm api rails db:seed

# コンテナ立ち上げ
docker compose up (-dでバックグランドで起動させる)

# コンテナ停止
docker compose down

# statusの確認
docker compose ps

# rspecの実行
docker compose run --rm api bundle exec rspec

# もしtestDBがない場合は
docker-compose run web rails db:create RAILS_ENV=test
docker-compose run web rails db:migrate RAILS_ENV=test

# rubocopの実行
docker compose run --rm api bundle exec rubocop -a
```
