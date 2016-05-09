include:
  - common
  - common.supervisor

graphite_python_deps:
  pip:
    - installed
    - force_reinstall: true
    - require:
      - sls: common
    - pkgs:
      - Django < 1.9
      - django-tagging
      - pytz
      - service_identity
      - cairocffi
      - gunicorn
      - whisper

graphite-web:
  pip:
    - installed
    - force_reinstall: true
    - require:
      - pip: graphite_python_deps
    - install_options:
      - --prefix=/opt/graphite
      - --install-lib=/opt/graphite/webapp

carbon:
  pip:
    - installed
    - force_reinstall: true
    - require:
      - pip: graphite_python_deps
    - install_options:
      - --prefix=/opt/graphite
      - --install-lib=/opt/graphite/lib

/opt/graphite/conf:
  file.recurse:
    - source: salt://opt/graphite/conf
    - user: root
    - group: root
    - file_mode: 644
    - dir_mode: 755
    - template: jinja
    - require:
      - pip: graphite-web

/opt/graphite/webapp/graphite:
  file.directory:
    - exists: true
    - makedirs: True
    - require:
      - pip: graphite-web

/opt/graphite/webapp/graphite/graphite_wsgi.py:
  file.symlink:
    - target: /opt/graphite/conf/graphite.wsgi.example
    - require:
      - file: /opt/graphite/webapp/graphite

/opt/graphite/webapp/graphite/local_settings.py:
  file.managed:
    - source: salt://opt/graphite/webapp/graphite/local_settings.py.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pip: graphite-web

initialize_sqlite:
  cmd:
    - run
    - name: python manage.py migrate --noinput
    - cwd: /opt/graphite/webapp/graphite/
    - require:
      - file: /opt/graphite/webapp/graphite/local_settings.py
    - unless:
      - cmd: test -f /opt/graphite/storage/graphite.db

/etc/supervisor/conf.d/graphiteweb.conf:
  file.managed:
    - source: salt://etc/supervisor/conf.d/conf.jinja
    - template: jinja
    - context:
      processname: graphiteweb
      command: gunicorn graphite_wsgi:application --bind 0.0.0.0:8888
      run_as: root
      autostart: true
      autorestart: true
      directory: /opt/graphite/webapp/graphite
    - require:
      - sls: common.supervisor
      - cmd: initialize_sqlite
  cmd.wait:
    - name: supervisorctl reload
    - watch:
      - file: /etc/supervisor/conf.d/graphiteweb.conf

/etc/supervisor/conf.d/carbon.conf:
  file.managed:
    - source: salt://etc/supervisor/conf.d/conf.jinja
    - template: jinja
    - context:
      processname: carbon
      command: python /opt/graphite/bin/carbon-cache.py --nodaemon --config=/opt/graphite/conf/storage-schemas.conf start
      run_as: root
      autostart: true
      autorestart: true
      directory: /opt/graphite
    - require:
      - sls: common.supervisor
      - file: /opt/graphite/conf
  cmd.wait:
    - name: supervisorctl reload
    - watch:
      - file: /etc/supervisor/conf.d/carbon.conf
