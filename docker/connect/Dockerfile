FROM ubuntu:trusty 
ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt-get update && \
	apt-get install -y --no-install-recommends wget && \
	wget -O kerio-connect-linux-64bit.deb http://download.kerio.com/dwn/kerio-connect-linux-64bit.deb && \
	dpkg -i kerio-connect-linux-64bit.deb || \
	apt-get install -y -f --no-install-recommends && \
	rm -f kerio-connect-linux-64bit.deb && \
	apt-get clean && \
	apt-get autoclean && \
	apt-get autoremove -y && \
	rm -rf /tmp/* /var/tmp/* && \
	rm -rf /var/lib/apt/lists/*

EXPOSE 4040 25 465 587 110 995 143 993 119 563 389 636 80 443 5222 5223

VOLUME /opt/kerio/mailserver/store
VOLUME /opt/kerio/mailserver/license
VOLUME /opt/kerio/mailserver/sslca

ADD entrypoint /entrypoint

ENTRYPOINT /entrypoint
