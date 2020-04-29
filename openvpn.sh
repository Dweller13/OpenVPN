#!/bin/bash

# Define parameters
USERNAME=					# your username to store configuration archives
HOMEDIR=/home/$USERNAME

    # Launch script
    echo "OpenVPN user-management script"
    echo
    echo "What do you want to do?"
    echo "   1) Add a new user"
    echo "   2) Revoke an existing user"
    echo "   3) Exit"
    read -p "Select an option [1-3]: " option
    case $option in
      1)
      # Generate certs
      echo
      echo "Input a client name"
      echo "Please, use one word only, no special characters."
      read -p "Client name: " -e CLIENT
      cd /etc/openvpn/certs/
      source ./vars
      ./build-key $CLIENT
      wait
      # Make an archive and copy to user's home folder
      cp /etc/openvpn/clients/client-common.txt /etc/openvpn/clients/$CLIENT.ovpn
      echo "cert $CLIENT.crt" >> /etc/openvpn/clients/$CLIENT.ovpn
      echo "key $CLIENT.key" >> /etc/openvpn/clients/$CLIENT.ovpn
      tar cJf /etc/openvpn/clients/$CLIENT.tar.xz -C /etc/openvpn/certs/keys ca.crt $CLIENT.crt $CLIENT.key ta.key -C /etc/openvpn/clients/ $CLIENT.ovpn
      wait
      cp /etc/openvpn/clients/$CLIENT.tar.xz $HOMEDIR/
      chown $USERNAME:$USERNAME $HOMEDIR/$CLIENT.tar.xz
      rm -f /etc/openvpn/clients/$CLIENT.ovpn
      echo
      echo "Client $CLIENT added, configuration archive is available at: $HOMEDIR/$CLIENT.tar.xz"
      exit
      ;;
      2)
      # List and select existing clients to revoke
      NUMBEROFCLIENTS=$(tail -n +2 /etc/openvpn/certs/keys/index.txt | grep -c "^V")
      if [[ "$NUMBEROFCLIENTS" = '0' ]]; then
        echo
        echo "You have no existing clients!"
        exit
      fi
      echo
      echo "Select the existing client certificate you want to revoke:"
      tail -n +2 /etc/openvpn/certs/keys/index.txt | grep "^V" | cut -d '=' -f 7 | cut -d '/' -f 1 | nl -s ') '
      if [[ "$NUMBEROFCLIENTS" = '1' ]]; then
        read -p "Select one client [1]: " CLIENTNUMBER
      else
        read -p "Select one client [1-$NUMBEROFCLIENTS]: " CLIENTNUMBER
      fi
      CLIENT=$(tail -n +2 /etc/openvpn/certs/keys/index.txt | grep "^V" | cut -d '=' -f 7 | cut -d '/' -f 1 | sed -n "$CLIENTNUMBER"p)
      echo
      read -p "Do you really want to revoke access for client $CLIENT? [y/N]: " -e REVOKE
      if [[ "$REVOKE" = 'y' || "$REVOKE" = 'Y' ]]; then
        cd /etc/openvpn/certs/
        source ./vars
        ./revoke-full $CLIENT
        rm -f /etc/openvpn/crl.pem
        cp /etc/openvpn/certs/keys/crl.pem /etc/openvpn/crl.pem
        # CRL is read with each client connection
        chown openvpn:nogroup /etc/openvpn/crl.pem
        echo
        echo "Certificate for client $CLIENT revoked!"
      else
        echo
      echo "Certificate revocation for client $CLIENT aborted!"
      fi
      exit
      ;;
      3) exit;;
    esac
  done
else
  clear
fi