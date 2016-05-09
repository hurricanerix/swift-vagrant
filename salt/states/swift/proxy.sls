include:
  - swift.base

/etc/swift/mime.types:
  file.managed:
    - source: salt://etc/swift/proxy.d/mime.types
    - user: swift
    - group: swift
    - mode: 644
    - require:
      - user: swift

/etc/swift/proxy-server.conf:
  file.managed:
    - source: salt://etc/swift/proxy.d/proxy-server.conf.jinja
    - user: swift
    - group: swift
    - mode: 644
    - template: jinja
