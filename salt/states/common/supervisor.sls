supervisor:
  pkg:
    - installed
    - hold: True

supervisor_svc:
  service:
    - running
    - name: supervisor
    - enable: True
    - require:
      - pkg: supervisor
