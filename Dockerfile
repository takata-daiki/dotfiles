FROM ubuntu:bionic

ARG GID=1000

ENV USER hrbt
ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
  && apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y \
    build-essential \
    curl \
    file \
    git \
    language-pack-ja \
    sudo \
    tzdata

ENV TZ Asia/Tokyo
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
RUN update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" \
  && echo "${TZ}" > /etc/timezone \
  && rm /etc/localtime \
  && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata

RUN groupadd -g ${GID} ${USER} \
  && useradd -g ${GID} -G sudo -m -s /bin/bash ${USER} \
  && echo "${USER}:${USER}" | chpasswd

RUN echo "Defaults visiblepw" >> /etc/sudoers
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USER}
WORKDIR /home/${USER}/

CMD ["/bin/bash"]
