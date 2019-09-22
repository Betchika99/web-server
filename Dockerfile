FROM ubuntu:18.04

USER root

RUN apt-get -y update
RUN apt-get install -y ruby-full

ENV APP /root/app
ADD ./ $APP
WORKDIR $APP

EXPOSE 5000

CMD ruby main.rb
