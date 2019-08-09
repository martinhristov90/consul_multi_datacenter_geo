#!/usr/bin/env bash

cat << EOF > /home/vagrant/socat_server.sh
#!/bin/bash

handle() {
  echo 'HTTP/1.0 200 OK'
  echo 'Content-Type: text/plain'
  echo "Date: \$(date)"
  echo "Server: \$SOCAT_SOCKADDR:$SOCAT_SOCKPORT"
  echo "Client: \$SOCAT_PEERADDR:$SOCAT_PEER_PORT"
  echo 'Connection: close'
  echo
  cat
}

case \$1 in
  "bind")
    socat -T0.05 -v tcp-l:8080,reuseaddr,fork,crlf system:". \$0 && handle"
    ;;
esac
EOF

bash /home/vagrant/socat_server.sh bind & > /dev/null 2>&1

cat << EOF > /etc/consul.d/service_web.json
{
    "service": {
        "name": "web",
        "port": 8080,
        "tags": ["v1.2.4"],
        "check": {
            "http": "http://localhost:8080",
            "interval": "10s"
        }
    }
}
EOF

# Renew configcd 
#consul reload
