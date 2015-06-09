#!/bin/sh
# Optionally add -v ~/.m2:/root/.m2 to map to a local maven repository for the demos
docker run -d \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v ~/.boot2docker/certs/boot2docker-vm/:/certs \
      -v ~/.m2:/root/.m2 \
      -p 9000:9000 -p 57575:57575 -p 35729:35729 \
      jolokia/redhat-msa-day:london-2015 1>&2

if [ $? -ne "0" ]; then
   echo "Error starting container: $?" 1>&2
   echo "http://cdn.shopify.com/s/files/1/0535/6917/products/problemsdemotivator.jpeg?v=1403276101"
   exit 1
fi

# Let the container warm up
sleep 3

rm $log

if [ x$DOCKER_HOST = x ]; then
   host="localhost"
else
   echo $DOCKER_HOST | grep -q "^unix";
   if [ $? -ne 0 ]; then
     host=$(echo $DOCKER_HOST | sed -e "s/[^/]*\/\/\([^:/]*\).*/\1/")
   else
     host="localhost"
   fi
fi
echo "http://$host:9000/"

