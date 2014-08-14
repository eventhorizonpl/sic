#!/bin/sh

cd /opt/solr/example/
/usr/bin/java -Dsolr.solr.home=multicore -jar /opt/solr/example/start.jar &
