FROM php:7.4-cli

RUN apt-get update

RUN apt-get install -y libmagickwand-dev wget --no-install-recommends
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev zlib1g-dev libzip-dev wget git zip unzip

RUN docker-php-ext-install -j$(nproc) gd

RUN pecl install imagick
RUN docker-php-ext-install mysqli pdo_mysql exif zip
RUN docker-php-ext-enable imagick

RUN pecl install grpc
RUN docker-php-ext-enable grpc

RUN pecl install protobuf
RUN docker-php-ext-enable protobuf

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '8a6138e2a05a8c28539c9f0fb361159823655d7ad2deecb371b04a83966c61223adc522b0189079e3e9e277cd72b8897') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir=/usr/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /usr/bin/cloud_sql_proxy
RUN chmod +x /usr/bin/cloud_sql_proxy
