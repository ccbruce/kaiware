#FROM ubuntu:22.04
FROM nvidia/cuda:11.4.3-cudnn8-devel-ubuntu20.04
#FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04
#gpu version#FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04 
#gpu version#FROM nvidia/cuda:12.2.2-devel-ubuntu22.04
#FROM ubuntu:jammy #22...

ENV DEBIAN_FRONTEND noninteractive \
    LC_ALL C.UTF-8 \
    TZ Asia/Taipei 

RUN groupadd --gid 2001 dev \
  && useradd --uid 11000 --gid dev --shell /usr/bin/bash --create-home node \
  && useradd --uid 11003 --gid dev --shell /usr/bin/bash --create-home ccbruce \
  && useradd --uid 11005 --gid dev --shell /usr/bin/bash --create-home mis   \ 
  && useradd --uid 12001 --gid dev --shell /usr/bin/bash --create-home dev01 \
  && useradd --uid 12002 --gid dev --shell /usr/bin/bash --create-home dev02 
  
ENV NB_USER ccbruce

RUN apt-get update -y  \
 #   && apt-get dist-upgrade \
    && apt-get install -qqqy --no-install-recommends \
        software-properties-common \
        libx11-6 lsb-release dctrl-tools gpg-agent gnupg gnupg2 bash \
        git gcc g++ make autoconf pkg-config \
        zip unzip ca-certificates bzip2\
        re2c nano htop iotop lsof cron mariadb-client redis-tools \
        busybox wget curl vim tzdata tree sshpass iputils-ping net-tools telnet gawk \
        locales openssh-server sudo \
        dnsutils supervisor dumb-init ghostscript imagemagick ffmpeg libgdiplus \
        sqlite3 file  poppler-utils openssl \
        nginx procps git-lfs ufw haproxy certbot \
        tar apt-utils autoconf automake build-essential \
        python3 python3-venv python3-pip python3-dev python3-setuptools build-essential python3-opencv \
        python3-certbot-nginx python3-acme ruby-shadow tini  \
        rustc \
    && mkdir -p /etc/nginx /etc/backup/nginx /etc/backup/bind /etc/backup/haproxy \
    && cp -fr /etc/nginx/* /etc/backup/nginx \
    && cp -fr /etc/haproxy/* /etc/backup/haproxy \ 
    && dpkg-reconfigure locales \
    && apt-get clean \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt update -y \
    && apt install python3-dev -y \
    && apt install python-is-python3 \
    && rm -rf ~/.cache/pip /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN nvcc --version 
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update -y \
    && apt-get install -y dotnet-sdk-7.0

### Mojo
#RUN curl https://get.modular.com | \
#  MODULAR_AUTH=mut_fe303dc5ca504bc4867a1db20d897fd8 \
#  sh - \
#  && modular install mojo 

RUN pip install ipykernel \
  #&& echo 'export MODULAR_HOME="/root/.modular"' >> ~/.bashrc \
  #&& echo 'export PATH="/root/.modular/pkg/packages.modular.com_mojo/bin:$PATH"' >> ~/.bashrc \
  #&& echo 'export MODULAR_HOME="/root/.modular"' >> /home/ccbruce/.bashrc \
  #&& echo 'export PATH="/root/.modular/pkg/packages.modular.com_mojo/bin:$PATH"' >> /home/ccbruce/.bashrc \
  #&& echo 'export MODULAR_HOME="/root/.modular"' >> /home/dev01/.bashrc \
  #&& echo 'export PATH="/root/.modular/pkg/packages.modular.com_mojo/bin:$PATH"' >> /home/dev01/.bashrc \
  && chown ccbruce /home/ccbruce/.bashrc && chown dev01 /home/dev01/.bashrc
###


### AI
##RUN pip install torch torchvision tensorflow
### Docker environment setup
ADD vimrc vimrc

COPY docker-entrypoint.sh /opt/startup/docker-entrypoint.sh

RUN  echo 'export PATH="/workspace/bin:$PATH"' >> /home/ccbruce/.bashrc \
    && mkdir -p /opt/startup /workspace /var/workspace /var/my-docker /var/repository && chmod 777 /workspace\
    && mv vimrc ~/ \
    && mv ~/vimrc ~/.vimrc \
    && mkdir /var/run/sshd \
    && adduser ccbruce sudo \
    && echo 'ccbruce ALL=(ALL:ALL) ALL' >> /etc/sudoers \
    && echo 'dev01 ALL=(ALL:ALL) ALL' >> /etc/sudoers \
    && echo 'ccbruce:mithra35' | chpasswd \
    && echo 'dev01:mithra35' | chpasswd \
    && sed -i "s/#Port.*/Port 22/" /etc/ssh/sshd_config \
    && sed -i "s/#PasswordAuthentication.*/PasswordAuthentication no/" /etc/ssh/sshd_config \
    && sed -i "s/PasswordAuthentication.*/PasswordAuthentication no/" /etc/ssh/sshd_config \
    && sed -i "s/UsePAM.*yes/UsePAM no/" /etc/ssh/sshd_config \
    && sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/" /etc/ssh/sshd_config \
    && sed -i "s/#UsePAM.*yes/UsePAM no/" /etc/ssh/sshd_config \
    && sed -i "s/#StrictModes yes/StrictModes no/" /etc/ssh/sshd_config \
    && sed -i "s/#PubkeyAuthentication.*/PubkeyAuthentication yes/" /etc/ssh/sshd_config \
    && echo "KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group14-sha1" >> /etc/ssh/sshd_config \
    && echo "*****SSH login fix. Otherwise user is kicked off after login*****" \
    #&& sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && mkdir -p /var/log/supervisor \
    && touch /opt/startup/monitor.log \
    && touch /var/log/supervisor/supervisord.log \
    && chmod 666 /var/log/supervisor/supervisord.log \
    && chmod +x /opt/startup/docker-entrypoint.sh \
    && rm -rf ~/.cache/pip /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22 19999 29999

USER root

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/opt/startup/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

