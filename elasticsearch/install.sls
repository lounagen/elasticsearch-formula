# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "elasticsearch/map.jinja" import elasticsearch with context %}

elasticsearch-java-pkg:
  pkg.installed:
    - name: {{ elasticsearch.java.pkg }}
    - refresh: true

{% if grains['os'] in ('Ubuntu', 'Debian') %}
elasticsearch-repo:
  pkgrepo.managed:
    - humanname: {{ elasticsearch.repo.humanname }}
    - name: {{ elasticsearch.repo.name }}
    - file: {{ elasticsearch.repo.file }}
    - keyid: {{ elasticsearch.repo.keyid }}
    - keyserver: {{ elasticsearch.repo.keyserver }}
    - gpgcheck: 1
    - require_in:
      - pkg: elasticsearch-pkg

{% elif grains['os'] == 'Raspbian' %}
/tmp/{{ elasticsearch.deb.name }}.deb:
   file.managed:
      - source: {{ elasticsearch.deb.source }}
      - source_hash: {{ elasticsearch.deb.source_hash }}

elasticsearch-dpkg-install:
    cmd.run:
      - names:
        - dpkg -i /tmp/{{ elasticsearch.deb.name }}.deb
        - apt-get install -y
      - unless: dpkg -s {{ elasticsearch.pkg }}
      - require:
        - file: /tmp/{{ elasticsearch.deb.name }}.deb
{% endif %}

{%- for data_directory in elasticsearch.conf.path.data.split(',') %}
{{ data_directory }}:
  file.directory:
    - user: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - file_mode: 644
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
{%- endfor %}

{%- for log_directory in elasticsearch.conf.path.logs.split(',') %}
{{ log_directory }}:
  file.directory:
    - user: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - file_mode: 644
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
{%- endfor %}

elasticsearch-pkg:
  pkg.installed:
    - name: {{ elasticsearch.pkg }}
    - refresh: true
    - require:
      - pkg: elasticsearch-java-pkg

