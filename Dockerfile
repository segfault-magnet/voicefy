FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Sarajevo
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone

RUN apt-get update && apt-get -y install python3.9 python3-pip jq sox curl && rm -rf /var/lib/apt/lists/*

RUN curl -O \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

RUN conda install -c conda-forge ffmpeg

RUN pip3 install spleeter

RUN mkdir -p /opt/models/2stems && curl -L "https://github.com/deezer/spleeter/releases/download/v1.4.0/2stems.tar.gz" | tar xvz -C /opt/models/2stems

COPY processors /opt/processors
COPY utility /opt/utility

WORKDIR /opt
