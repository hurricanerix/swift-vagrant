include:
  - common
  - common.supervisor

diamond:
  pip.installed:
    - name: diamond
    - require:
      - sls: common

/etc/diamond:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 775
    - makedirs: True
    - require:
      - pip: diamond

/etc/diamond/collectors:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 775
    - makedirs: True
    - require:
      - file: /etc/diamond

/var/log/diamond:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 775
    - makedirs: True
    - require:
      - file: /etc/diamond

/etc/diamond/diamond.conf:
  file.managed:
    - source: salt://etc/diamond/diamond.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/diamond

/etc/supervisor/conf.d/diamond.conf:
  file.managed:
    - source: salt://etc/supervisor/conf.d/conf.jinja
    - template: jinja
    - context:
      processname: diamond
      command: /usr/local/bin/diamond -f -c /etc/diamond/diamond.conf -u root -g root --skip-fork --log-stdout
      run_as: root
      autostart: true
      autorestart: true
      directory: /
    - require:
      - sls: common.supervisor
      - file: /etc/diamond/diamond.conf
      - pip: diamond
  cmd.wait:
    - name: supervisorctl reload
    - watch:
      - file: /etc/supervisor/conf.d/diamond.conf
