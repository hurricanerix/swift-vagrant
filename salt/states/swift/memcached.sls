memcached:
  pkg:
    - installed
    - skip_verify: True

/etc/memcached.conf:
  file.managed:
    - source: salt://etc/memcached.conf.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: memcached
  service:
    - running
    - name: memcached
    - enable: True
    - require:
      - pkg: memcached
    - watch:
      - file: /etc/memcached.conf
