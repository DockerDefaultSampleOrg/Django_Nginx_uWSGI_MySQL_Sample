#!/bin/sh

# Dockerコンテナを一括で停止・削除（開発用）
docker compose -f docker-compose.dev.yml down -v
# Dockerコンテナを一括で停止・削除（本番用）
# docker compose -f docker-compose.prod.yml down -v

# 停止中のDockerコンテナを一括で削除
docker container rm $(docker ps -a -q)

# Dockerイメージを一括で削除
docker image rm $(docker images -q)

# Dockerのシステムなどを削除
docker system prune
