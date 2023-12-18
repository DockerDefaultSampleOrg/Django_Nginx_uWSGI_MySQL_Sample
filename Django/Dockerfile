FROM python:3.12.0-bullseye
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN mkdir app
WORKDIR /app
RUN mkdir -p tmp/sockets
COPY requirements.txt /app/
RUN pip install -U pip && pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "manage.py", "runserver", "0.0.0.0:8000" ]