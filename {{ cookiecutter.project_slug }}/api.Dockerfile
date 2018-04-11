FROM python:3.6.4-alpine3.7

LABEL maintainer="{{ cookiecutter.full_name }} {{ cookiecutter.email}}"

# So gevent can be installed
RUN apk add --no-cache g++
RUN apk add --no-cache python python-dev

COPY ./api/requirements.txt /code/
WORKDIR /code
RUN pip install -r requirements.txt

COPY ./site.cfg /code/
COPY ./package.json /code/
COPY ./api/src /code/src
