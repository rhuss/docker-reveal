#!/bin/sh
echo "Starting docker container 'rhuss/docker-reveal'"

docker run -it --rm \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v `pwd`/slides:/slides \
      -v ~/.m2:/root/.m2 \
      -p 9000:9000 -p 57575:57575 -p 35729:35729 \
      rhuss/docker-reveal $*
