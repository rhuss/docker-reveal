## Public presentations

This directory contains script which, if executed, will pull and startup a fixed presentation as Docker image. 
As single output you get an URL which can directly pipe to your browser. And if you combine the URL of the script
with a URL link shortener, you can fire up your presentation as elegantly as
 
````
open $(curl -sL bit.ly/docker-for-java-devs | sh)
````

