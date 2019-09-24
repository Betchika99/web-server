FROM ubuntu:18.04
FROM ruby:latest

USER root

RUN apt-get -y update
RUN apt-get install -y ruby-full

ENV APP=/root/app

ADD ./ $APP
WORKDIR $APP

EXPOSE 80

CMD ruby src/main.rb
