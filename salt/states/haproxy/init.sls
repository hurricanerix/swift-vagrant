include:
  - haproxy.packages
  - haproxy.files

haproxy_svc:
  service:
    - running
    - name: haproxy
    - enable: True
    - require:
      - pkg: haproxy_pkg
    - watch:
      - file: /etc/haproxy/haproxy.cfg
