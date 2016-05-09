include:
  - common.supervisor

statsdaemon_server:
  archive.extracted:
    - name: /opt/
    - source: https://github.com/bitly/statsdaemon/releases/download/v0.7.1/statsdaemon-0.7.1.linux-amd64.go1.4.2.tar.gz
    - source_hash: md5=42d932699925b9256bf92753579ce69a
    - archive_format: tar
    - tar_options: z
    - user: root
    - group: root
    - keep: false
    - if_missing: /opt/statsdaemon-0.7.1.linux-amd64.go1.4.2/

/usr/local/bin/statsdaemon:
  file.symlink:
    - target: /opt/statsdaemon-0.7.1.linux-amd64.go1.4.2/statsdaemon
    - require:
      - sls: common.supervisor
      - archive: statsdaemon_server

{% set server, statsd_addr = salt['mine.get']('roles:statsd', 'network.ip_addrs', expr_form='grain').items()[0] %}
{% set server, graphite_addr = salt['mine.get']('roles:graphite', 'network.ip_addrs', expr_form='grain').items()[0] %}
/etc/supervisor/conf.d/statsdaemon.conf:
  file.managed:
    - source: salt://etc/supervisor/conf.d/conf.jinja
    - template: jinja
    - context:
      processname: statsdaemon
      command: /usr/local/bin/statsdaemon -address="{{ statsd_addr[0] }}:8125" -percent-threshold=25 -percent-threshold=50 -percent-threshold=75 -percent-threshold=90 -percent-threshold=100 -prefix="stats." -receive-counter="wtf." -graphite="{{ graphite_addr[0] }}:2003"
      run_as: root
      autostart: true
      autorestart: true
      directory: /
    - require:
      - file: /usr/local/bin/statsdaemon
      - sls: common.supervisor
  cmd.wait:
    - name: supervisorctl reload
    - watch:
      - file: /etc/supervisor/conf.d/statsdaemon.conf
