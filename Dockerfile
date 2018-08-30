FROM alpine:latest
MAINTAINER ohaddahan@gmail.com
LABEL 'label'='haproxy_tor'

RUN apk update
RUN apk upgrade
RUN apk add \
    haproxy ruby bash curl shadow bash-completion tor \
    ruby-irb ruby-rake ruby-io-console ruby-bigdecimal ruby-json ruby-bundler ruby-dev \
    --update \
    --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main

#RUN  groupadd --force -g 123 appuser
#RUN  useradd  -r -g appuser appuser
#USER appuser

CMD mkdir -p            /haproxy_tor/run_area/
ADD haproxy.cfg.erb     /haproxy_tor/run_area/haproxy.cfg.erb
ADD proxy_setup.rb      /haproxy_tor/run_area/proxy_setup.rb
ADD torrc.cfg.erb       /haproxy_tor/run_area/torrc.cfg.erb
ADD run_haproxy_tor.rb  /haproxy_tor/run_area/run_haproxy_tor.rb
RUN chmod +x            /haproxy_tor/run_area/run_haproxy_tor.rb

ENV haproxy_cfg_erb=/haproxy_tor/run_area/haproxy.cfg.erb
ENV haproxy_port=10000
ENV haproxy_stat_port=10100
ENV number_of_tors=10
ENV torrc_cfg_erb=/haproxy_tor/run_area/torrc.cfg.erb
ENV starting_tor_http_tunnel_port=15000
ENV tor_exit_node=us
ENV username=username
ENV password=password

EXPOSE 10000 10100 15000

CMD ruby /haproxy_tor/run_area/run_haproxy_tor.rb

# docker build -t 'haproxy-tor' .
# docker run -it <image> /bin/bash
# docker run -it haprox-tor:latest /bin/bash
# docker exec -i -t 665b4a1e17b6 /bin/bash
# docker run -d -p 10000:10000 -p 10100:10100 -p 15000:15000 -e number_of_tors=15 haprox-tor:latest
# docker run -d -p 10000:20000 -p 10100:20100 -p 15000:25000 -e number_of_tors=15 -e haproxy-port=20000 -e haproxy_stat_port=20100 -e starting_tor_http_tunnel_port=25000 haprox_tor:latest
