FROM docker.cucloud.net/base

# Need to use old source list for apache22, this is required by CUWA
RUN mv /etc/apt/sources.list /tmp
COPY precise-sources.list /etc/apt/sources.list.d/precise-sources.list

# Install.
RUN \
  apt-get update && \
  apt-get install -y apache2 && \
  apt-get clean

# copy files needed for CUWA
COPY conf/cuwebauth.load /etc/apache2/mods-available/cuwebauth.load
COPY lib/libcom_err.so.3 /lib/libcom_err.so.3
COPY lib/mod_cuwebauth.so /usr/lib/apache2/modules/mod_cuwebauth.so

## copy keytbabs
RUN mkdir /infra/

# turn on mods
RUN \ 
  a2enmod ssl \
  cuwebauth \
  rewrite \
  proxy \
  proxy_http 

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]