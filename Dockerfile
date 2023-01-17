FROM ubuntu/apache2
LABEL maintainer="Rafael Cerqueira <rafascerqueira.dev@gmail.com>"
WORKDIR /
COPY /znuny-6.0.48 /opt/otrs
RUN apt update && apt install -y systemctl cron cpanminus
RUN useradd -d /opt/otrs -c 'Znuny user' -g www-data -s /bin/bash -M -N otrs
RUN cp /opt/otrs/Kernel/Config.pm.dist /opt/otrs/Kernel/Config.pm
RUN /opt/otrs/bin/otrs.SetPermissions.pl
RUN apt -y install libapache2-mod-perl2 libdbd-mysql-perl libtimedate-perl libnet-dns-perl libnet-ldap-perl libio-socket-ssl-perl libpdf-api2-perl libsoap-lite-perl libtext-csv-xs-perl libjson-xs-perl libapache-dbi-perl libxml-libxml-perl libxml-libxslt-perl libyaml-perl libarchive-zip-perl libcrypt-eksblowfish-perl libencode-hanextra-perl libmail-imapclient-perl libtemplate-perl libdatetime-perl libmoo-perl bash-completion libyaml-libyaml-perl libjavascript-minifier-xs-perl libcss-minifier-xs-perl libauthen-sasl-perl libauthen-ntlm-perl
RUN ln -s /opt/otrs/scripts/apache2-httpd.include.conf /etc/apache2/conf-available/zzz_znuny.conf
RUN a2enmod perl headers deflate filter cgi
RUN a2dismod mpm_event
RUN a2enmod mpm_prefork
RUN a2enconf zzz_znuny
EXPOSE 80
EXPOSE 443
CMD ["apachectl", "-DFOREGROUND"]

