# Dockerfile for a reveal.js environment with java, maven und docker cli

# Start it with
# docker run -it --rm \
#       -v /var/run/docker.sock:/var/run/docker.sock \
#       -v `pwd`:/slides \
#       -p 9000:9000 -p 57575:57575 -p 35279:35279 \
#       rhuss/docker-reveal
#
# See also /start.sh for possible options

FROM alpine:3.2

ENV MAVEN_VERSION 3.3.1
ENV MAVEN_BASE apache-maven-${MAVEN_VERSION}

RUN apk update && \
    apk upgrade && \
    apk add \
          nodejs \
          python \
          python-dev \
          musl-dev \
          libffi-dev \
          openssl-dev \
          py-pip \
          gcc \
          g++ \
          openjdk7 \
          git \
          vim \
          docker && \
    pip install --upgrade pip && \
    pip install libsass && \
    npm install -g npm && \
    npm install -g grunt-cli bower yo generator-reveal && \
    wget http://www.eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_BASE}-bin.tar.gz \
         -O /tmp/maven.tgz && \
    tar zxvf /tmp/maven.tgz && mv ${MAVEN_BASE} /maven && \
    ln -s /maven/bin/mvn /usr/bin/ && \
    rm /usr/bin/vi && ln -s /usr/bin/vim /usr/bin/vi && \
    rm /tmp/maven.tgz /var/cache/apk/* && \
    cd / && \
    git clone https://github.com/paradoxxxzero/butterfly && \
    cd butterfly && \
    cat /butterfly/coffees/term.coffee | sed -e 's/@cursorBlink\s*=\s*true/@cursorBlink = false/' > /tmp/term.coffee && \
    mv /tmp/term.coffee /butterfly/coffees/term.coffee && \
    python setup.py build && \
    python setup.py install && \
    cp /etc/terminfo/x/xterm-color /etc/terminfo/x/xterm-256color && \
    mkdir /slides && \
    adduser -D -h /slides -s /bin/ash -u 1000 yo

ADD docker/start.sh /start.sh
ADD docker/cacerts /usr/lib/jvm/default-jvm/jre/lib/security/
ADD docker/butterfly /etc/butterfly
ADD docker/slides_init /slides_init
RUN chmod 755 /usr/bin/mvn /start.sh

EXPOSE 9000 57575 35729

WORKDIR /slides
ENTRYPOINT ["sh", "/start.sh"]
