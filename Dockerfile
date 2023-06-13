# Use latest Debian as base
FROM debian:10

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en

# Update system and install packages
RUN apt-get update \
    && apt-get install -y \
    wget \
    lsb-release \
    apt-transport-https \
    ca-certificates

# Add PHP 7.1 repository
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.1.list \
    && wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -

# Setting up locales
RUN apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

# Set root password for MySQL
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

# Update and install PHP 7.1 and extensions
RUN apt-get update \
    && apt-get install -y \
    php7.1 \
    php7.1-apcu \
    php7.1-bcmath \
    php7.1-cli \
    php7.1-curl \
    php7.1-gd \
    php7.1-geoip \
    php7.1-gettext \
    php7.1-imagick \
    php7.1-intl \
    php7.1-json \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-memcached \
    php7.1-mysql \
    php7.1-sqlite3 \
    php7.1-xdebug \
    php7.1-xml \
    php7.1-xmlrpc \
    php7.1-zip \
    memcached \
    imagemagick \
    openssh-client \
    curl \
    gettext \
    zip \
    git \
    subversion \
    perl \
    python2.7 \
    python3.5 \
    mariadb-server

# Install additional tools (Composer, Node.js, Yarn, etc)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn n mocha grunt-cli webpack gulp

# Specify work directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80

CMD ["php", "-S", "0.0.0.0:80", "-t", "/var/www/html"]
