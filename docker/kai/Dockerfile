FROM php:8.2-fpm
#FROM ubuntu:jammy 

ENV DEBIAN_FRONTEND noninteractive \
    LC_ALL C.UTF-8 \
    TZ Asia/Taipei 

RUN groupadd --gid 1000 node \
  && groupadd --gid 1001 editor \
  && groupadd --gid 2001 dev \
  && useradd --uid 1000 --gid node --shell /usr/bin/bash --create-home node \
  && useradd --uid 1002 --gid editor --shell /usr/bin/bash --create-home editor \
  && useradd --uid 1003 --gid editor --shell /usr/bin/bash --create-home ccbruce \
  && useradd --uid 1004 --gid editor --shell /usr/bin/bash --create-home kag  \
  && useradd --uid 1005 --gid editor --shell /usr/bin/bash --create-home mis   \ 
  && useradd --uid 2001 --gid dev --shell /usr/bin/bash --create-home dev01 \
  && useradd --uid 2002 --gid dev --shell /usr/bin/bash --create-home dev02 
  
ENV NB_USER editor

RUN apt-get update -y  \
    #&& apt-get dist-upgrade \
    #&& apt-get install -y --no-install-recommends \
    #&&       software-properties-common  apt-transport-https \ 
    #&&       ca-certificates gnupg2  \
    #&& add-apt-repository ppa:certbot/certbot \
    #&& apt-get update -y  \
    && apt-get install -qqqy --no-install-recommends \
        lsb-release dctrl-tools gpg-agent gnupg gnupg2 bash \
        git gcc g++ make autoconf libc-dev pkg-config libzip-dev \
        zip unzip freetds-bin freetds-dev freetds-common \
        re2c nano htop iotop lsof cron mariadb-client redis-tools \
        busybox wget curl vim tzdata tree sshpass iputils-ping net-tools telnet gawk \
        locales openssh-server sudo nodejs yarn procps \
        #gvfs-bin\
        dnsutils supervisor dumb-init ghostscript imagemagick libgdiplus default-jdk \
        sqlite3 file  poppler-utils ghostscript openssl \
        golang default-mysql-client bzip2 git-lfs\
        #nginx nginx-plus-module-modsecurity \
        #openmediavault \
        #python-certbot-nginx \ 
        ufw bind9 haproxy certbot \
        python3 python3-venv python3-pip python3-dev python3-setuptools build-essential libopencv-dev python3-opencv \
        python3-certbot-nginx \
        python3-acme samba ruby-shadow tini mariadb-client redis-tools \
        wget tar apt-utils autoconf automake build-essential git \
    && mkdir -p /etc/nginx /etc/backup/nginx /etc/backup/bind /etc/backup/haproxy /etc/backup/samba /etc/backup/samba2 \
    ##&& cp -fr /etc/nginx/* /etc/backup/nginx \
    && cp -fr /etc/bind/*  /etc/backup/bind \
    && cp -fr /etc/haproxy/* /etc/backup/haproxy \ 
    && cp -fr /etc/samba/*   /etc/backup/samba \
    #&& ln -s /usr/bin/bash /bin/bash \
    #&& update-alternatives --install /usr/bin/python python /usr/bin/python3.5 1
    && apt-get install -qqqy --no-install-recommends \
        libcurl4-openssl-dev libgeoip-dev liblmdb-dev \
        libpcre++ \
        libtool libxml2 libxml2-dev libssl-dev libyajl-dev pkgconf zlib1g-dev \
        libmemcached-dev libfcgi0ldbl \
        libz-dev \
        libpq-dev \
        libssl-dev libssl-doc libsasl2-dev \
        libmcrypt-dev \
        libxml2-dev \
        zlib1g-dev libicu-dev \
        libldap2-dev libbz2-dev \
        libcurl4-openssl-dev \
        libgmp-dev firebird-dev libib-util \
        libpng++-dev \
        libwebp-dev libjpeg-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libvpx-dev libfreetype6-dev \
        libmagick++-dev \
        libmagickwand-dev \
        zlib1g-dev libgd-dev \
        libtidy-dev libxslt1-dev libmagic-dev libexif-dev file \
        libsqlite3-dev libxslt-dev \
        libmhash2 libmhash-dev libc-client-dev libkrb5-dev libssh2-1-dev \
        libpcre3 libpcre3-dev \
        libmagickwand-6.q16-dev libsnmp-dev libedit-dev libreadline6-dev libsodium-dev \
        libct4 libsybdb5 tdsodbc \
        libreadline-dev librecode-dev libpspell-dev libonig-dev \
        libfcgi0ldbl \
     && dpkg-reconfigure locales \
     && apt-get clean \
     && rm -rf ~/.cache/pip /var/lib/apt/lists/* /tmp/* /var/tmp/*

### WAF

RUN mkdir -p /home/src && cd /home/src && \
    git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity && \
    cd ModSecurity && \
    git submodule init && \
    git submodule update && \
        ./build.sh && \
	./configure && \
	make && \
	make install && \
	cd / && \
	git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git && \
	wget http://nginx.org/download/nginx-1.25.1.tar.gz && \
	tar zxvf nginx-1.25.1.tar.gz && \
	cd nginx-1.25.1 && \
	./configure  --prefix=/var/www/html --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf \
                     --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --with-pcre  \
                     --lock-path=/var/lock/nginx.lock --pid-path=/var/run/nginx.pid --with-http_ssl_module \
                     --with-http_v2_module --with-stream=dynamic --with-http_addition_module --with-http_mp4_module \
                     --with-http_image_filter_module=dynamic --modules-path=/etc/nginx/modules \
                     --user=root --group=root --with-debug --with-ipv6 --with-http_ssl_module  --with-compat \
                     --add-module=/ModSecurity-nginx --without-http_access_module --without-http_auth_basic_module \
                     --without-http_autoindex_module --without-http_empty_gif_module --without-http_fastcgi_module \
                     --without-http_referer_module --without-http_memcached_module --without-http_scgi_module \
                     --without-http_split_clients_module --without-http_ssi_module --without-http_uwsgi_module && \
	make && \
	make install && \
	cd /home/src && \
	git clone https://github.com/coreruleset/coreruleset.git /usr/src/owasp-modsecurity-crs && \
	cp -R /usr/src/owasp-modsecurity-crs/rules /etc/nginx/  && \
	mv /etc/nginx/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example  /etc/nginx/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf && \
	mv /etc/nginx/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example  /etc/nginx/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf \
    &&	apt-get autoremove -y \
    && apt-get clean \
    && rm -rf ~/.cache/pip /var/lib/apt/lists/* /tmp/* /var/tmp/*

#COPY nginx.conf /usr/local/nginx/conf/nginx.conf
#COPY modsec_includes.conf /usr/local/nginx/conf/modsec_includes.conf
#COPY modsecurity.conf /usr/local/nginx/conf/modsecurity.conf
#COPY crs-setup.conf /usr/local/nginx/conf/rules/crs-setup.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY modsec_includes.conf /etc/nginx/modsec_includes.conf
COPY modsecurity.conf /etc/nginx/modsecurity.conf
COPY crs-setup.conf /etc/nginx/rules/crs-setup.conf
#CMD ./usr/local/nginx/sbin/nginx -g 'daemon off;'

RUN cp -fr /etc/nginx/* /etc/backup/nginx 

### setup jupyter

RUN mv /usr/lib/python3.11/EXTERNALLY-MANAGED /usr/lib/python3.11/EXTERNALLY-MANAGED.bak && \
    pip install jupyter \
        ansible-kernel \
        bash_kernel \
        bioblend galaxy-ie-helpers \
        biopython \
        cloudpickle \
        cython \
        dill \
        # octave_kernel \
        # Scala
        # spylon-kernel \
        # Java
        # scijava-jupyter-kernel \
        jupytext \
        jupyterlab-geojson \
        jupyterlab-katex \
        jupyterlab-fasta \
        mamba \
        patsy \
        pyodbc

RUN pip install jupyterlab_hdf && \
    rm -r ~/.cache/pip

ADD ./startup.sh /startup.sh
#ADD ./monitor_traffic.sh /monitor_traffic.sh
ADD ./get_notebook.py /get_notebook.py

# We can get away with just creating this single file and Jupyter will create the rest of the
# profile for us.
RUN mkdir -p /home/$NB_USER/.ipython/profile_default/startup/ && \
    mkdir -p /home/$NB_USER/.jupyter/custom/

COPY ./ipython-profile.py /home/$NB_USER/.ipython/profile_default/startup/00-load.py
COPY jupyter_notebook_config.py /home/$NB_USER/.jupyter/
COPY jupyter_lab_config.py /home/$NB_USER/.jupyter/

ADD ./custom.js /home/$NB_USER/.jupyter/custom/custom.js
ADD ./custom.css /home/$NB_USER/.jupyter/custom/custom.css
ADD ./default_notebook.ipynb /home/$NB_USER/notebook.ipynb

# ENV variables to replace conf file
ENV DEBUG=false \
    GALAXY_WEB_PORT=10000 \
    NOTEBOOK_PASSWORD=none \
    CORS_ORIGIN=none \
    DOCKER_PORT=none \
    API_KEY=none \
    HISTORY_ID=none \
    REMOTE_HOST=none \
    GALAXY_URL=none


# @jupyterlab/google-drive  not yet supported

USER root
# /import will be the universal mount-point for Jupyter
# The Galaxy instance can copy in data that needs to be present to the Jupyter webserver
RUN mkdir -p /import/jupyter/outputs/ && \
    mkdir -p /import/jupyter/data && \
    mkdir /export/ && \
    chown -R $NB_USER:users /home/$NB_USER/ /import /export/

### setup webmin
WORKDIR /home
RUN echo deb https://download.webmin.com/download/repository sarge contrib >> /etc/apt/sources.list \
    && wget http://www.webmin.com/jcameron-key.asc \
    && apt-key add jcameron-key.asc \
    && apt-get update -y \
    && apt-get install -qqqy --no-install-recommends webmin \
    && apt-get clean \
    #&&  echo "#! /bin/bash" > webmin_exe.sh \
    #&&  echo "sed -i 's;ssl=1;ssl=0;' /etc/webmin/miniserv.conf \
    #&& systemctl enable cron \
    #&& service webmin start && tail -f /dev/null" >> webmin_exe.sh \
    #&& chmod 755 webmin_exe.sh  
    #&& apt clean \
    && rm -rf ~/.cache/pip /var/lib/apt/lists/* /tmp/* /var/tmp/*


### setup php

ENV EXT_APCU_VERSION=5.1.17 EXT_REDIS_VERSION=4.3.0 EXT_IGBINARY_VERSION=3.0.1

# fix for docker-php-ext-install pdo_dblib
# https://stackoverflow.com/questions/43617752/docker-php-and-freetds-cannot-find-freetds-in-know-installation-directories

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
        docker-php-ext-install imap iconv \
    &&  ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/ \
    &&  docker-php-ext-install pdo_dblib  \
    &&  docker-php-ext-install bcmath bz2 calendar ctype curl dba dom \
    &&  docker-php-ext-install fileinfo exif ftp gettext gmp \
    &&  docker-php-ext-install intl ldap mbstring mysqli \
    &&  docker-php-ext-install opcache pcntl pspell \
    &&  docker-php-ext-install pdo_mysql pdo_pgsql pdo_sqlite pgsql phar posix \
    &&  docker-php-ext-install session shmop simplexml soap sockets sodium \
    &&  docker-php-ext-install sysvmsg sysvsem sysvshm \
    &&  docker-php-ext-install snmp xml xsl tidy zip filter \
    &&  php -m \
    && docker-php-source extract \
    # ext-opache
    && docker-php-ext-enable opcache \
    # ext-igbinary
    #&& mkdir -p /usr/src/php/ext/igbinary \
    #&& curl -kfsSL https://github.com/igbinary/igbinary/archive/$EXT_IGBINARY_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/igbinary --strip 1 \ 
    #&& docker-php-ext-install igbinary  \
    # ext-redis
    #&& curl -fsSL https://github.com/phpredis/phpredis/archive/$EXT_REDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    #&& docker-php-ext-configure redis --enable-redis-igbinary \
    && mkdir -p /usr/src/php/ext/redis \
    && curl -k -fsSL https://github.com/phpredis/phpredis/archive/refs/tags/5.3.5.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && docker-php-ext-configure redis \
    #&& /usr/local/php8/bin/phpize \
    && docker-php-ext-install redis \
    # ext-apcu
    && mkdir -p /usr/src/php/ext/apcu \
    #&& curl -fsSL https://github.com/krakjoe/apcu/archive/v$EXT_APCU_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/apcu --strip 1 \
    #&& docker-php-ext-install apcu \
    && mkdir -p /usr/src/php/ext/redis \
    && curl -k -fsSL https://pecl.php.net/get/apcu | tar xvz -C /usr/src/php/ext/apcu --strip 1 \
    && docker-php-ext-configure apcu \
    # ext-bcmath, ext-sockets
    && docker-php-ext-install bcmath sockets \
    && pecl install xdebug && docker-php-ext-enable xdebug \
    # Configure Xdebug
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.log=/var/www/html/xdebug/xdebug.log" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.discover_client_host=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.client_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && docker-php-ext-configure gd \
        --with-jpeg \
        --with-xpm \
        --with-webp \
        --with-freetype \
    && docker-php-ext-install -j$(nproc) gd \
# install composer
    &&  EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)" && \
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
        ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")" && \
        if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then >&2 echo 'ERROR: Invalid installer checksum' && exit 1; fi \
    && php composer-setup.php --quiet && rm composer-setup.php && \
        mv composer.phar /usr/local/sbin/composer && \
        chmod +x /usr/local/sbin/composer \
# install NewRelic agent
    &&  echo 'deb [trusted=yes] http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list && \
    curl https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install newrelic-php5 newrelic-sysmond && \
    export NR_INSTALL_SILENT=1 && newrelic-install install \
# install SendGrid
    &&  echo "postfix postfix/mailname string localhost" | debconf-set-selections && \
        echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections && \
        DEBIAN_FRONTEND=noninteractive apt-get install postfix libsasl2-modules -y \
    && apt-get clean \
    && rm -rf ~/.cache/pip /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install pecl extension
#RUN pecl install ds 
#RUN    pecl install imagick
#RUN    pecl install igbinary
#RUN    pecl install memcached 
#RUN    pecl install mcrypt

### .net
# Get Ubuntu version
RUN mkdir -p /home/ms
WORKDIR /home/ms
RUN  cat /etc/os-release \
    #&& source /etc/os-release \
    && echo `grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'` \
# Download Microsoft signing key and repository
    #&& wget https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
# Install Microsoft signing key and repository
    #&& dpkg -i packages-microsoft-prod.deb \
    && wget https://github.com/PowerShell/PowerShell/releases/download/v7.3.8/powershell_7.3.8-1.deb_amd64.deb -O powershell_7.3.8-1.deb_amd64.deb \
    && dpkg -i powershell_7.3.8-1.deb_amd64.deb \
# Clean up
    #&& rm packages-microsoft-prod.deb \
    && curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bookworm-prod bookworm main" | tee /etc/apt/sources.list.d/microsoft.list \
    && apt-get -y update \
    && wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x ./dotnet-install.sh \
    && ./dotnet-install.sh --install-dir /usr/bin/dotnet \
    && ./dotnet-install.sh  --runtime dotnet --install-dir /usr/bin/dotnet-runtime \
    && rm -rf ~/.cache/pip /var/lib/apt/lists/* /tmp/* /var/tmp/*

### Mojo


### setup node
ENV NODE_VERSION 16.16.0

### Java Environment
ADD apache-maven /usr/local/src/apache-maven
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV M2_HOME /usr/local/src/apache-maven
ENV MAVEN_HOME /usr/local/src/apache-maven
ENV PATH ${M2_HOME}/bin:${PATH}

### mojo

#RUN curl https://get.modular.com | \
#  MODULAR_AUTH=mut_fe303dc5ca504bc4867a1db20d897fd8 \
#  sh - \
#  && modular install mojo \
#  && pip install ipykernel \
#  && echo 'export MODULAR_HOME="/root/.modular"' >> ~/.bashrc \
#  && echo 'export PATH="/root/.modular/pkg/packages.modular.com_mojo/bin:$PATH"' >> ~/.bashrc \
#  && echo 'export MODULAR_HOME="/root/.modular"' >> /home/ccbruce/.bashrc \
#  && echo 'export PATH="/root/.modular/pkg/packages.modular.com_mojo/bin:$PATH"' >> /home/ccbruce/.bashrc \
#  && echo 'export MODULAR_HOME="/root/.modular"' >> /home/dev01/.bashrc \
#  && echo 'export PATH="/root/.modular/pkg/packages.modular.com_mojo/bin:$PATH"' >> /home/dev01/.bashrc \
#  && chown ccbruce /home/ccbruce/.bashrc && chown dev01 /home/dev01/.bashrc

### AI
##RUN pip install torch torchvision tensorflow
### Docker environment setup
ADD vimrc vimrc
COPY docker-entrypoint.sh /opt/startup/docker-entrypoint.sh

RUN echo 'export PATH="/usr/bin/dotnet-runtime:/usr/bin/dotnet:/workspace/bin:$PATH"' >> /home/ccbruce/.bashrc \
    && echo 'export PATH="/usr/bin/dotnet-runtime:/usr/bin/dotnet:/workspace/bin:$PATH"' >> /home/dev01/.bashrc \
    && echo 'export PATH="/usr/bin/dotnet-runtime:/usr/bin/dotnet:/workspace/bin:$PATH"' >> /home/dev02/.bashrc \
    && mkdir -p /opt/startup /workspaces /var/workspaces /var/my-docker /var/repository && chmod 777 /workspaces\
    &&  mv vimrc ~/ \
    && mv ~/vimrc ~/.vimrc \
    && chmod a+x /usr/local/src/apache-maven/bin/mvn \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && mkdir /var/run/sshd \
    && adduser ccbruce sudo \
    && adduser kag sudo \
    && adduser mis sudo \
    && echo 'ccbruce ALL=(ALL:ALL) ALL' >> /etc/sudoers \
    && echo 'kag ALL=(ALL:ALL) ALL' >> /etc/sudoers \
    && echo 'dev01 ALL=(ALL:ALL) ALL' >> /etc/sudoers \
    #&& echo 'root:Mit!^hra!^35!^' | chpasswd \
    && echo 'ccbruce:mithra35' | chpasswd \
    && echo 'mis:mithra35' | chpasswd \
    && echo 'dev01:mithra35' | chpasswd \
    && sed -i "s/#Port.*/Port 22/" /etc/ssh/sshd_config \
    && sed -i "s/#PasswordAuthentication.*/PasswordAuthentication no/" /etc/ssh/sshd_config \
    && sed -i "s/PasswordAuthentication.*/PasswordAuthentication no/" /etc/ssh/sshd_config \
    && sed -i "s/UsePAM.*yes/UsePAM no/" /etc/ssh/sshd_config \
    && sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/" /etc/ssh/sshd_config \
    && sed -i "s/#UsePAM.*yes/UsePAM no/" /etc/ssh/sshd_config \
    && sed -i "s/#StrictModes yes/StrictModes no/" /etc/ssh/sshd_config \
    && sed -i "s/#PubkeyAuthentication.*/PubkeyAuthentication yes/" /etc/ssh/sshd_config \
    #&& sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config \
    #&& sed -i "s/#PasswordAuthentication.*/PasswordAuthentication yes/" /etc/ssh/sshd_config \
    && echo "KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group14-sha1" >> /etc/ssh/sshd_config \
    && echo "*****SSH login fix. Otherwise user is kicked off after login*****" \
    #&& sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && sed -i "s/\/usr\/local\/nginx\/conf\//\/etc\/nginx\//" /etc/nginx/nginx.conf \
    && sed -i "s/\/ModSecurity\/unicode.mapping/conf\/\/home\/src\/ModSecurity\/unicode.mapping/" /etc/nginx/modsecurity.conf \
    && sed -i "s/include rules\/REQUEST-910-IP-REPUTATION.conf/#include rules\/REQUEST-910-IP-REPUTATION.conf/" /etc/nginx/modsec_includes.conf \
    && mkdir -p /var/log/supervisor \
    && touch /opt/startup/monitor.log \
    && touch /var/log/supervisor/supervisord.log \
    && chmod 666 /var/log/supervisor/supervisord.log \
    && chmod +x /opt/startup/docker-entrypoint.sh \
    && mkdir -p /var/www/html/xdebug \
    && touch /var/www/html/xdebug/xdebug.log \
    #add .bashrc
    && echo "export XDEBUG_CONFIG=\"idekey=VSCODE\"" >> ~/.basrc \
    && sed -i 's/9000/9003/g' /usr/local/etc/php/conf.d/xdebug.ini  \
    && echo "xdebug.idekey=VSCODE" >> /usr/local/etc/php/conf.d/xdebug.ini \
#####samba
    addgroup -S smb && \
    adduser -S -D -H -h /tmp -s /sbin/nologin -G smb -g 'Samba User' smbuser &&\
    file="/etc/samba/smb.conf" && \
    sed -i 's|^;* *\(log file = \).*|   \1/dev/stdout|' $file && \
    sed -i 's|^;* *\(load printers = \).*|   \1no|' $file && \
    sed -i 's|^;* *\(printcap name = \).*|   \1/dev/null|' $file && \
    sed -i 's|^;* *\(printing = \).*|   \1bsd|' $file && \
    sed -i 's|^;* *\(unix password sync = \).*|   \1no|' $file && \
    sed -i 's|^;* *\(preserve case = \).*|   \1yes|' $file && \
    sed -i 's|^;* *\(short preserve case = \).*|   \1yes|' $file && \
    sed -i 's|^;* *\(default case = \).*|   \1lower|' $file && \
    sed -i '/Share Definitions/,$d' $file && \
    echo '   pam password change = yes' >>$file && \
    echo '   map to guest = bad user' >>$file && \
    echo '   usershare allow guests = yes' >>$file && \
    echo '   create mask = 0664' >>$file && \
    echo '   force create mode = 0664' >>$file && \
    echo '   directory mask = 0775' >>$file && \
    echo '   force directory mode = 0775' >>$file && \
    echo '   force user = smbuser' >>$file && \
    echo '   force group = smb' >>$file && \
    echo '   follow symlinks = yes' >>$file && \
    echo '   load printers = no' >>$file && \
    echo '   printing = bsd' >>$file && \
    echo '   printcap name = /dev/null' >>$file && \
    echo '   disable spoolss = yes' >>$file && \
    echo '   strict locking = no' >>$file && \
    echo '   aio read size = 0' >>$file && \
    echo '   aio write size = 0' >>$file && \
    echo '   vfs objects = catia fruit recycle streams_xattr' >>$file && \
    echo '   recycle:keeptree = yes' >>$file && \
    echo '   recycle:maxsize = 0' >>$file && \
    echo '   recycle:repository = .deleted' >>$file && \
    echo '   recycle:versions = yes' >>$file && \
    echo '' >>$file && \
    echo '   # Security' >>$file && \
    echo '   client ipc max protocol = SMB3' >>$file && \
    echo '   client ipc min protocol = SMB2_10' >>$file && \
    echo '   client max protocol = SMB3' >>$file && \
    echo '   client min protocol = SMB2_10' >>$file && \
    echo '   server max protocol = SMB3' >>$file && \
    echo '   server min protocol = SMB2_10' >>$file && \
    echo '' >>$file && \
    echo '   # Time Machine' >>$file && \
    echo '   fruit:delete_empty_adfiles = yes' >>$file && \
    echo '   fruit:time machine = yes' >>$file && \
    echo '   fruit:veto_appledouble = no' >>$file && \
    echo '   fruit:wipe_intentionally_left_blank_rfork = yes' >>$file && \
    echo '' >>$file && \
    rm -rf /tmp/*

EXPOSE 22 53 5353 1433 1053 80 8080 8888 8443 443 137/udp 138/udp 139 445 18000 28000 38000 48000 58000 10000 50000 50001 50002

# 启动Jupyter Notebook
# CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

USER root
#HEALTHCHECK --interval=60s --timeout=15s \
#            CMD smbclient -L \\localhost -U % -m SMB3
#VOLUME ["/etc", "/var/cache/samba", "/var/lib/samba", "/var/log/samba",\
#            "/run/samba"]

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/opt/startup/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

