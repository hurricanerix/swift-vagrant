include:
  - common

setuptools:
  pip:
    - name: setuptools >= 17.1
    - installed
    - force_reinstall: true
    - require:
      - sls: common

swift_source:
  git.latest:
    - name: https://github.com/openstack/swift.git
    {%- if pillar['swift_object_server'] == "hummingbird" %}
    - rev: feature/hummingbird
    {%- else %}
    - rev: master
    {% endif %}
    - target: /srv/swift
    - force: true
    - force_checkout: true

swift_source_install:
  pip:
    - name: /srv/swift/
    - installed
    - upgrade: true
    - force_reinstall: true
    - require:
      - pip: setuptools
      - git: swift_source
