# Django + Nginx + uWSGI + MySQL
---

1. envファイルの作成
 - 開発用のenvファイル「.env.dev」ファイルを作成する。
 - 本番用のenvファイル「.env.prod」ファイルを作成する。
 
 【例】
```
# MYSQLのルートパスワードがないとコンテナが起動しない
# MYSQL_ROOT_PASSWORD="任意のルートパスワード"
MYSQL_ROOT_PASSWORD=root
# MYSQL_DATABASE="任意のデータベース名"
MYSQL_DATABASE=djangodb
# MYSQL_USER="任意のユーザ名"
MYSQL_USER=django
# MYSQL_PASSWORD="任意のパスワード"
MYSQL_PASSWORD=django
# MYSQL_HOST="MySQLのサービス名"
MYSQL_HOST=db
# MYSQL_PORT="MySQLのポート番号"
MYSQL_PORT=3306

PMA_ARBITRARY=1
# MySQLのサービス名を指定
PMA_HOST=db
PMA_USER=root
# MySQLのrootユーザのパスワード
PMA_PASSWORD=root
```

2. Djangoのプロジェクト構成を作成する。
```
docker compose -f docker-compose.dev.yml run app django-admin startproject <プロジェクト名> .
```

3. <プロジェクト名>/settings.pyを設定する。
```
# osのモジュールをインポート
import os

# ALLOWED_HOSTS = []
ALLOWED_HOSTS = ['*']

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        # 'DIRS': [],
        'DIRS': [os.path.join(BASE_DIR, 'templates')],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

# DATABASES = {
#     'default': {
#         'ENGINE': 'django.db.backends.sqlite3',
#         'NAME': BASE_DIR / 'db.sqlite3',
#     }
# }

# MySQLのパラメータを.envから取得
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        # コンテナ内の環境変数をDATABASESのパラメータに反映
        "NAME": os.environ.get("MYSQL_DATABASE"),
        "USER": os.environ.get("MYSQL_USER"),
        "PASSWORD": os.environ.get("MYSQL_PASSWORD"),
        "HOST": os.environ.get("MYSQL_HOST"),
        "PORT": os.environ.get("MYSQL_PORT"),
    }
}

# LANGUAGE_CODE = 'en-us'

# TIME_ZONE = 'UTC'

# 言語を日本語に設定
LANGUAGE_CODE = 'ja'
# タイムゾーンをAsia/Tokyoに設定
TIME_ZONE = 'Asia/Tokyo'

# STATIC_ROOTを設定
# Djangoの管理者画面にHTML、CSS、Javascriptが適用されます
STATIC_ROOT = "/static/"
STATIC_URL = "/static/"
```

4. Djangoアプリ構成を作成する。
```
docker compose -f docker-compose.dev.yml run app python manage.py startapp <アプリ名>
```

5. <プロジェクト名>/settings.pyにアプリを追加する。
```
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    '<アプリ名>',
]
```

6. Dockerを削除する。
```
# docker-compose.dev.ymlのコンテナを一括で停止・削除
docker compose -f docker-compose.dev.yml down -v

# Dockerイメージを一括で削除
docker image rm $(docker images -q)

# Dockerのシステムなどを削除（実行後、yを入力）
docker system prune

```

7. Dockerを起動する。
```
docker compose -f docker-compose.dev.yml up -d --build
```

8. 起動確認する。
```
http://localhost:8000
```

9. 各Djangoのコマンド実行方法。
```
# マイグレーションを実行
docker compose -f docker-compose.dev.yml exec app python manage.py makemigrations <アプリ名> --noinput
docker compose -f docker-compose.dev.yml exec app python manage.py migrate --noinput

# staticのファイルをsettings.pyで指定した場所に集める
docker compose -f docker-compose.dev.yml exec app python manage.py collectstatic --noinput

# スーパーユーザー作成
docker compose -f docker-compose.dev.yml exec app python manage.py createsuperuser
```

10. 本番用の設定
- django/uwsgi.iniをアプリ用に修正する。
- 本番用Dockerを起動する。
```
docker compose -f docker-compose.prod.yml up -d --build
```

11. 本番環境の起動確認する。
```
http://localhost
```
---

- 開発用、起動方法
```
docker compose -f docker-compose.dev.yml up -d --build
```

- 本番用、起動方法
```
docker compose -f docker-compose.prod.yml up -d --build
```


---

- Git運用方法
```
# git clone https://github.com/Purewest-Project/TempleManagement.git

# git flow初期化
git flow init -d

# ローカルブランチとリモートブランチを紐付ける
git push -u origin develop

# featureで開発開始
git flow feature start feature_name
(例)
git flow feature start '#nishi_plot'

# 作業をステージングに上げる
git add .

# git commit
git commit -m '<作業内容>'

# コミットしたものをPushする
git push -u origin 'feature/<ブランチ名>'
(例)
git push -u origin 'feature/#nishi_plot'

# featureブランチでの作業終了
git flow feature finish feature_name
(例)
git flow feature finish '#nishi_plot'
(これで自動的にdevelopブランチにチェックアウトされる)

```