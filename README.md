## OpenVPN

### openvpn.sh
Inspired by [Nyr's openvpn-installer](https://github.com/Nyr/openvpn-install)

Made for already installed OpenVPN server on Debian/Ubuntu from repo

Simple script for adding/revoking OpenVPN users
- Set your username to store archive in your home folder for further `scp` or `sftp`
- Add `crl-verify crl.pem` at the end of your server.conf file
- Remove `--interact` from `/etc/openvpn/certs/build-key`
