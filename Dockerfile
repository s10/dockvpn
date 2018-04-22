FROM alpine:latest

RUN apk add --update bash easy-rsa openvpn iptables socat curl wget openvpn python2

ADD ./bin /usr/local/sbin
VOLUME /etc/openvpn

# openvpn ports
ENV PORT_TCP 1195
ENV PORT_UDP 1195

# web interface port
ENV PORT_CONTROL 8000

# use self-signed cert
ENV SSL 1

# web interface will be disabled without settings credentials
#ENV CONTROL_USERNAME username123
#ENV CONTROL_PASSWORD password456

# domain name can be specified here for generating ovpn configs
ENV EXTERNAL_ADDRESS ""

EXPOSE ${PORT_TCP}/tcp ${PORT_UDP}/udp ${PORT_CONTROL}/tcp
CMD run
