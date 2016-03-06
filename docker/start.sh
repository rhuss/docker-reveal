#!/bin/sh

O=`getopt -l "markdown,attributes,notes" ishfn:  "$@"` || exit 1
usage=`cat <<EOT
Usage: 

   docker run -it -p \\\\
              -v /var/run/docker.sock:/var/run/docker.sock \\\\
              -v $(pwd)/slides:/slides \\\\
              -v ~/.m2:/root/.m2 \\\\
              -p 9000:9000 -p 57575:57575 -p 35729:35729 \\\\
              jolokia/docker-reveal \\\\
              [options]

   with the following options:
    
   -i         Initialize /slides with a sample presentation
   -f         Force initialization even when /slides already contains content
   -s         Run a shell instead of starting up 'grunt serve'
   -n "Title" Create a new slide. The following additional options are supported
                 --markdown   : Create markdown
                 --attributes : Add attributes in list.json
                 --notes      : Add speaker notes
   -h  This help message

The following ports are mapped:
   
    9000 - HTTP Port for reveal presentations
   57575 - HTTP Port for Butterfly terminal emulation
   35279 - Live Reload port
EOT
`
eval set -- "$O"
slide_opts=""
while true; do
    case "$1" in
	      -i)	init=1;
            shift;;
        -f) force=1;
            shift;;
        -s) shell=1;
            shift;;
        -n) shift;
            slide=$1;
            shift;;
        --markdown|--attributes|--notes) slide_opts="$slide_opts $1";
            shift;;
        --) shift; break;;
        *)  echo "${usage}"; exit 1;;
    esac
done

if [ ${init} ]; then
    if [ -e "/slides/index.html" -a ! ${force} ]; then
        echo "Refusing to overwrite non empty slides directory. Use -f to force this."
        exit 1
    fi
    echo "Initialising slides (might take a bit) ...."
    if [ ! -e "/slides" ]; then
        mkdir /slides;
        chown yo /slides;
    fi
    cp -r /slides_init/* /slides/
fi

if [ ${shell} ]; then
    # Start shell and quite
    exec sh
fi

if [ -n "${slide}" ]; then
    if [ ! -e "/slides/index.html" ]; then
        echo "/slides must be initialized for creating new slides";
        exit 1
    fi
    cd /slides
    su yo -c "yo --no-insight reveal:slide \"$slide\" $slide_opts"
    exit 0
fi

# Start butterfly server in the background
/butterfly/butterfly.server.py --motd='' --unsecure --host=0.0.0.0 --login=false --cmd="ash -l" &

# Server slides
cd /slides
grunt serve
