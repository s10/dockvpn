# OpenVPN for Docker

## Instructions:

### Start container with OpenVPN from localy built image

Docker image could be build from the git repository https://github.com/s10/dockvpn

### Start container with OpenVPN from Docker Hub image

```bash
docker run -ti -d -v $HOME/configs:/etc/openvpn --cap-add=NET_ADMIN --restart unless-stopped \
--name dockvpn -e PORT_TCP=1194 -e PORT_UDP=1194 -e PORT_CONTROL=8000 \
-e CONTROL_USERNAME=username123 -e CONTROL_PASSWORD=password456 -e EXTERNAL_ADDRESS="yourdomain.com" \
-p 1194:1194/udp -p 1194:1194/tcp -p 8000:8000/tcp esten/dockvpn
```

Config files will be available at the web interface. It's URL will be shown after the container start. Web interface uses HTTPS with the self-signed certificate. At this interface you can generate multiple OpenVPN profiles for different clients.

If you reboot the server (or stop the container) and you `docker run` again, all your configuration will preserve.

## How does it work?

When the `esten/dockvpn` image is started, it generates:

- Diffie-Hellman parameters,
- a private key,
- a self-certificate matching the private key,
- two OpenVPN server configurations (for UDP and TCP).

Then, it starts two OpenVPN server processes (by default on 1195/udp and 1195/tcp).

The configuration is located in `/etc/openvpn`, and the Dockerfile declares that directory as a volume.

UI with basic HTTP auth starts at the 8000/tcp. If username and password is not specified, than web server will not be started.

## OpenVPN details

We use `tun` mode, because it works on the widest range of devices.
`tap` mode, for instance, does not work on Android, except if the device is rooted.

The topology used is `net30`, because it works on the widest range of OS. `p2p`, for instance, does not work on Windows.

The TCP server uses `192.168.255.0/25` and the UDP server uses `192.168.255.128/25`.

The client profile specifies `redirect-gateway def1`, meaning that after establishing the VPN connection, all traffic will go through the VPN. This might cause problems if you use local DNS recursors which are not directly reachable, since you will try to reach them through the VPN and they might not answer to you. If that happens, use public DNS resolvers like those of Google (8.8.4.4 and 8.8.8.8) or OpenDNS (208.67.222.222 and 208.67.220.220).

## Original Projects

**the original project - [jpetazzo/dockvpn](https://github.com/jpetazzo/dockvpn)** and it has its own [automatic build on dockerhub](https://hub.docker.com/r/jpetazzo/dockvpn/).

