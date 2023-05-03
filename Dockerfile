FROM ubuntu/apache2

RUN apt update && apt upgrade -y

COPY znuny-6.5.2 /opt/znuny-6.5.2

RUN ln -s /opt/znuny-6.5.2 /opt/otrs

RUN useradd -d /opt/otrs -c 'Znuny user' -g www-data -s /bin/bash -M -N otrs

RUN cp /opt/otrs/Kernel/Config.pm.dist /opt/otrs/Kernel/Config.pm

RUN /opt/otrs/bin/otrs.SetPermissions.pl

RUN apt install -y cpanminus libapache2-mod-perl2 libdbd-mysql-perl libtimedate-perl libnet-dns-perl libnet-ldap-perl libio-socket-ssl-perl libpdf-api2-perl libsoap-lite-perl libtext-csv-xs-perl libjson-xs-perl libapache-dbi-perl libxml-libxml-perl libxml-libxslt-perl libyaml-perl libarchive-zip-perl libcrypt-eksblowfish-perl libencode-hanextra-perl libmail-imapclient-perl libtemplate-perl libdatetime-perl libmoo-perl bash-completion libyaml-libyaml-perl libjavascript-minifier-xs-perl libcss-minifier-xs-perl libauthen-sasl-perl libauthen-ntlm-perl libhash-merge-perl libical-parser-perl libspreadsheet-xlsx-perl libcrypt-jwt-perl libcrypt-openssl-x509-perl jq

RUN cpanm install Jq

RUN ln -s /opt/otrs/scripts/apache2-httpd.include.conf /etc/apache2/conf-available/zzz_znuny.conf

RUN a2enmod perl headers deflate filter cgi

RUN a2dismod mpm_event

RUN a2enmod mpm_prefork

RUN a2enconf zzz_znuny

RUN /etc/init.d/apache2 restart

RUN su - otrs

EXPOSE 80

CMD ["apache2-foreground"]