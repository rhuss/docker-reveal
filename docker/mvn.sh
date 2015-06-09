#!/bin/sh

# Setup Docker environment. If '/certs' is mounted then use SSL
host=$(ip route show 0.0.0.0/0 | grep -Eo 'via \S+' | awk '{print $2}');
if [ -f /certs/key.pem ]; then
  # If certs are mounted, use SSL ...
  export DOCKER_CERT_PATH=/certs
  export DOCKER_TLS_VERIFY=1
  export DOCKER_HOST=tcp://${host}:2376
else
  # ... otherwise use plain http
  export DOCKER_TLS_VERIFY=0
  export DOCKER_HOST=tcp://${host}:2375
fi
export JAVA_HOME=/usr/lib/jvm/default-jvm
/maven/bin/mvn $*