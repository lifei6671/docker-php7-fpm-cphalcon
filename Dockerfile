FROM daocloud.io/library/php:7.0.10-fpm

MAINTAINER Minho <longfei6671@163.com>

#COPY php-memcached /usr/src/php/ext/php-memcached
#COPY phpredis /usr/src/php/ext/phpredis
#COPY cphalcon /usr/src/php/ext/cphalcon

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
		libpcre3-dev \
		gcc \
		make \
        bzip2 \
	libbz2-dev \
	libmemcached-dev \
	git \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install ctype \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install zip 
    
WORKDIR /usr/src/php/ext/
RUN git clone -b php7 https://github.com/php-memcached-dev/php-memcached.git
RUN git clone -b php7 https://github.com/phpredis/phpredis.git 

RUN docker-php-ext-configure php-memcached \
	&& docker-php-ext-install php-memcached \
	&& docker-php-ext-configure phpredis \
	&& docker-php-ext-install phpredis

ENV PHALCON_VERSION=3.0.1

# Compile Phalcon
RUN set -xe && \
        curl -LO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz && \
        tar xzf v${PHALCON_VERSION}.tar.gz && cd cphalcon-${PHALCON_VERSION}/build && ./install && \
        echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini && \
        cd ../.. && rm -rf v${PHALCON_VERSION}.tar.gz cphalcon-${PHALCON_VERSION} 
        # Insall Phalcon Devtools, see https://github.com/phalcon/phalcon-devtools/
        #curl -LO https://github.com/phalcon/phalcon-devtools/archive/v${PHALCON_VERSION}.tar.gz && \
        #tar xzf v${PHALCON_VERSION}.tar.gz && \
        #mv phalcon-devtools-${PHALCON_VERSION} /usr/local/phalcon-devtools && \
        #ln -s /usr/local/phalcon-devtools/phalcon.php /usr/local/bin/phalcon
		
RUN cp /usr/local/etc/php/conf.d/phalcon.ini phalcon.ini
#RUN docker-php-ext-enable phalcon
#RUN apt-get -y remove --purge git
#RUN apt-get -y remove --purge make 
#RUN apt-get clean 
#RUN apt-get -y autoremove
#RUN apt-get -y autoclean
	