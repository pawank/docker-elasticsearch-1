Elasticsearch
=============

An Elasticsearch Docker image inspired by the structure of the Docker trusted
images, as well as Elasticsearch's own init script.

Usage
-----

Basic usage (using the `CMD` defined in the Dockerfile):

    docker run krallin/elasticsearch

Pass additional options with command line flags (but don't forget to pass
the executable name `elasticsearch` when you do that!):

    docker run krallin/elasticsearch elasticsearch -Des.node.name="Test"

You can of course add a volume and pass configuration to Elasticsearch using
the `-Des.config` flag.

https://registry.hub.docker.com/u/krallin/elasticsearch/
