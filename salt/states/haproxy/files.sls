haproxy_default:
  file.replace:
    - name: /etc/default/haproxy
    - pattern: 'ENABLED=0'
    - repl: 'ENABLED=1'
    - require:
      - sls: haproxy.packages
      - pkg: haproxy_pkg

haproxy_cfg:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://etc/haproxy/haproxy.cfg.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - sls: haproxy.packages
      - pkg: haproxy_pkg
