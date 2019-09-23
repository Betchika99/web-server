FROM ubuntu:18.04

USER root

RUN apt-get -y update
RUN apt-get install -y ruby-full

ENV APP /root/app
ENV CONFIG_PATH="/etc/httpd.conf"

COPY ./httpd.conf /etc/httpd.conf
ADD ./ $APP
WORKDIR $APP

EXPOSE 80

CMD ruby src/main.rb
