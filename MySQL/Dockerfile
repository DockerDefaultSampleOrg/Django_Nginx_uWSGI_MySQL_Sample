# MySQL8系のイメージを指定
FROM mysql:8.0.32

# MySQLのローカルの設定ファイルをコンテナにコピー
COPY ./my.cnf /etc/mysql/conf.d/my.cnf
# init.sqlをコンテナの/docker-entrypoint-init.db.dと共有
COPY ./init.sql /docker-entrypoint-initdb.d