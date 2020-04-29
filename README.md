# OpenVPN
Useful script(s), written during configuring and maintaining OpenVPN server

## openvpn.sh
Inspired by https://github.com/Nyr/openvpn-install
Made for standart Debian/Ubuntu OpenVPN server setup from repo

Simple script for adding/revoking OpenVPN users
- Set your username to store archive in your home folder for further `scp` or `sftp`
- Add `crl-verify crl.pem` at the end of your server.conf file
- Remove `--interact` from `/etc/openvpn/certs/build-key`