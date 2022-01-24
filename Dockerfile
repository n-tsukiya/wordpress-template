FROM wordpress:php7.4-apache

COPY ./config/php.ini-development /usr/local/etc/php/php.ini-development