FROM python:alpine3.7

ENV FLASK_APP='app.py'
ENV FLASK_ENV='development'

COPY requirements.txt /app/requirements.txt
WORKDIR /app

RUN pip install -r requirements.txt

COPY . /app
EXPOSE 5000
ENTRYPOINT ["python"]
CMD [ "app.py" ]