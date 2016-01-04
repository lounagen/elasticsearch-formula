# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.config

elasticsearch-name:
  service.running:
    - name: {{ elasticsearch.service.name }}
    - enable: True
    - watch:
      - file: elasticsearch-config
