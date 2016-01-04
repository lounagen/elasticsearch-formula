# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "elasticsearch/map.jinja" import elasticsearch with context %}

elasticsearch-config:
  file.managed:
    - name: {{ elasticsearch.config.elasticsearch_yaml }}
    - source: salt://elasticsearch/files/conf/elasticsearch.yml
    - template: jinja
    - mode: 640
    - user: root
    - group: {{ elasticsearch.group }}

