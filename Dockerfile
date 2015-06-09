# Dockerfile for RSA London presentation

# Start it with
# docker run -it --rm \
#       -v /var/run/docker.sock:/var/run/docker.sock \
#       -v `pwd`:/slides \
#       -v ~/.boot2docker/certs/boot2docker-vm/:/certs \
#       -p 9000:9000 -p 57575:57575 -p 35279:35279 \
#       jolokia/msa-redhat-london-2015

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
          docker \
          docker-bash-completion \
          gcr && \
    pip install --upgrade pip && \
    pip install libsass && \
    npm install -g npm && \
    npm install -g grunt-cli bower yo && \
    wget http://www.eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_BASE}-bin.tar.gz \
         -O /tmp/maven.tgz && \
    tar zxvf /tmp/maven.tgz && mv ${MAVEN_BASE} /maven && \
    rm /usr/bin/vi && ln -s /usr/bin/vim /usr/bin/vi && \
    rm /tmp/maven.tgz /var/cache/apk/*

RUN cd / && \
    git clone https://github.com/rhuss/butterfly.git && \
    cd butterfly && \
    cat /butterfly/coffees/term.coffee | sed -e 's/@cursorBlink\s*=\s*true/@cursorBlink = false/' > /tmp/term.coffee && \
    mv /tmp/term.coffee /butterfly/coffees/term.coffee && \
    python setup.py build && \
    python setup.py install

ADD docker/mvn.sh /usr/bin/mvn
ADD docker/start.sh /start.sh
ADD docker/cacerts /usr/lib/jvm/default-jvm/jre/lib/security/
ADD docker/butterfly /etc/butterfly

RUN chmod 755 /usr/bin/mvn /start.sh

EXPOSE 9000 57575 35729

WORKDIR /slides
CMD ["sh", "/start.sh" ]
