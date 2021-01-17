FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Sarajevo
RUN ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone

RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install python3 python3-pip ffmpeg jq sox curl

RUN pip3 install spleeter

RUN mkdir -p /opt/models/2stems && curl -L "https://github.com/deezer/spleeter/releases/download/v1.4.0/2stems.tar.gz" | tar xvz -C /opt/models/2stems

COPY processors /opt/processors
COPY utility /opt/utility

WORKDIR /opt
