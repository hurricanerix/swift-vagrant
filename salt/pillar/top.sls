base:
  '*':
    - globals

  'roles:graphite':
    - match: grain
    - graphite

  'roles:swift':
    - match: grain
    - swift

  'roles:memcached':
    - match: grain
    - memcached

  'roles:haproxy':
    - match: grain
    - haproxy

  'roles:syslog':
    - match: grain
    - syslog
