FROM java:openjdk-7-jre

ENV ES_USER elasticsearch
ENV ES_GROUP elasticsearch

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r "$ES_GROUP" && useradd -r -g "$ES_GROUP" "$ES_USER"

# grab gosu for easy step-down from root
RUN gpg --keyserver pgp.mit.edu --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* \
  && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
  && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && apt-get purge -y --auto-remove curl

# install Elasticsearch
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

ENV ES_MAJOR 1.4
ENV ES_DEBIAN_VERSION 1.4.2
RUN echo "deb http://packages.elasticsearch.org/elasticsearch/${ES_MAJOR}/debian stable main" > /etc/apt/sources.list.d/es.list

RUN apt-get update && apt-get install -y elasticsearch="$ES_DEBIAN_VERSION" && rm -rf /var/lib/apt/lists/*

# Configure environment
ENV PATH /usr/share/elasticsearch/bin:$PATH

ENV ES_HOME /usr/share/elasticsearch
ENV ES_DATA /var/lib/elasticsearch
ENV ES_LOGS /var/log/elasticsearch

VOLUME /var/lib/elasticsearch
VOLUME /var/log/elasticsearch

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9200 9300
CMD ["elasticsearch"]
