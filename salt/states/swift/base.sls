swift_deps_pkgs:
  pkg:
    - installed
    - pkgs:
      - xfsprogs

swift:
  group.present:
    - gid: 2000
    - system: true
  user.present:
    - gid_from_name: true
    - remove_groups: false
    - createhome: false
    - system: true
    - uid: 2000
    - require:
      - group: swift

/etc/swift:
  file.directory:
    - user: swift
    - group: swift
    - dir_mode: 775
    - makedirs: True
    - require:
      - user: swift

/etc/swift/swift.conf:
  file.managed:
    - source: salt://etc/swift/swift.conf.jinja
    - user: swift
    - group: swift
    - mode: 644
    - template: jinja
    - require:
      - file: /etc/swift

/etc/swift/memcache.conf:
  file.managed:
    - source: salt://etc/swift/memcache.conf.jinja
    - user: swift
    - group: swift
    - mode: 644
    - template: jinja
    - require:
      - file: /etc/swift

/var/run/swift:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

/var/cache/swift:
  file.directory:
    - user: swift
    - group: swift
    - dir_mode: 755
    - makedirs: True
    - require:
      - user: swift
