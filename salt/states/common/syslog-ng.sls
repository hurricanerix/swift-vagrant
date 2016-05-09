syslog-ng_pkgs:
  pkg:
    - installed
    - skip_verify: True
    - pkgs:
      - syslog-ng-mod-json
      - syslog-ng-mod-mongodb
      - syslog-ng-mod-sql
      - syslog-ng-core
      - syslog-ng

/etc/syslog-ng/syslog-ng.conf:
  file.managed:
    - source: salt://etc/syslog-ng/syslog-ng.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: syslog-ng_pkgs

syslog-ng_svc:
  service:
    - running
    - name: syslog-ng
    - enable: True
    - require:
      - pkg: syslog-ng_pkgs
    - watch:
      - file: /etc/syslog-ng/syslog-ng.conf
