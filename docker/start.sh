#!/bin/sh

/butterfly/butterfly.server.py --motd='' --unsecure --host=0.0.0.0 --login=false &
cd /slides
grunt serve