FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Sarajevo
RUN ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone

RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install python3 python3-pip

RUN apt-get -y install ffmpeg jq sox

RUN pip3 install spleeter

RUN apt-get -y install wget

RUN mkdir -p /opt/models && wget "https://github.com/deezer/spleeter/releases/download/v1.4.0/2stems.tar.gz" --directory-prefix /models/

COPY processors /opt/processors
COPY utility /opt/utility

WORKDIR /opt
