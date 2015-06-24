
## docker-reveal - A Docker image for reveal.js presentations

This docker image is useful for creating reveal.js presentations. It uses the Yeoman generator 
[generator-reveal](https://github.com/slara/generator-reveal) under the hoods.

### Features 

* Based on [Alpine Linux](https://www.alpinelinux.org/)
* [Butterfly](http://paradoxxxzero.github.io/2014/02/28/butterfly.html), a HTML 5 terminal emulation, 
  for inline terminal demos.  
* Docker client 
* Live Reload
* Java 7 and Maven 3.3.1
 
### Initialization

All your slides will be stored belong a certain directory, referred to `$SLIDES` from now on. In order to initialize 
a first simple set of slides (as `yo reveal` would do) mount `$SLIDES` into the container and 
run this image with the option `-i`:

````bash
docker run -ti \
           -p 9000:9000 -p 57575:57575 -p 35729:35729 \
           -v $SLIDES:/slides \
           rhuss/docker-reveal -i  
````

This will copy over a set of slides and start an HTTP server on port 9000. You can visit the demo slides by opening 
your browser at `http://dockerhost:9000/` where `dockerhost` is the IP address of you docker host (e.g. `localhost`).

You can now edit the files in `$SLIDES`. Any change will be picked up immediately and if you have [LiveReload](http://livereload.com/extensions/) installed 
your browser will refresh immediately. 

### Creating slides

Slides can be created easily with `yo`:

````bash
docker run -ti \
           -v $SLIDES:/slides \
           rhuss/docker-reveal -n "Slide title" [--markdown|--notes|--attributes]
````

This can be also done manually:

* Create a new slide in `$SLIDES/slides/`, either as HTML (`.html`) or Markdown (`.md`) file
* Add this slide to the list in `$SLIDES/slides/list.json` 

More options are available, please refer to `generator-reveal`'s [documentation](https://github.com/slara/generator-reveal) 
for details.

### Tips

* If you are using `mvn` in you demos, you might want to mount your local Maven repository to avoid unnecessary download 
  times. This can be done by adding a `-v ~/.m2:/root/.m2` to the Docker command line. Otherwise the container starts up
  with an empty local repository.
* In order to access the outer Docker daemon a `-v /var/run/docker.sock:/var/run/docker.sock` must be added so that the
  Unix socket is also available within the container. See [The Docker Wormhole Pattern](https://ro14nd.de/Docker-Wormhole-Pattern/) 
  for more information. 

### Finishing up

When you are finished with authoring you can create your own image containing your full presentation. This could also contain
the source of your applications which you demo. An example `Dockerfile` could look like:

````
FROM rhuss/docker-reveal:latest

# Add presentation slides (add here the $SLIDES dir as source directory 
ADD slides/ /

# Optionally checkout your source code and warm it up
RUN cd / && \
    git clone https://github.com/rhuss/docker-maven-sample.git && \
    cd docker-maven-sample && \
    mvn install
````

### Gotchas

The terminal emulation works quite nicely but is of course completely insecure with respect to your container. Please
keep this in mind. Also, the dynamic sizing of the iframe providing the Butterfly terminal emulation could be improved.
I happily will apply pull requests here ;-)
