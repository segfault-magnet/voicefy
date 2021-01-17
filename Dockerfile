FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Sarajevo
RUN ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone

RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install python3 python3-pip

RUN apt-get -y install ffmpeg

RUN pip3 install spleeter

COPY processors/ /opt/

WORKDIR /opt
