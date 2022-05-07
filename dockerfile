FROM python:3.9.12-buster

ENV FLASK_APP='app.py'
ENV FLASK_ENV='development'

COPY requirements.txt /app/requirements.txt
WORKDIR /app

RUN pip install -r requirements.txt

COPY . /app

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]