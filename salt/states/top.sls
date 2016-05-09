base:
  '*':
    - common
    - common.syslog-ng
    - common.diamond

  'roles:swift':
    - match: grain
    - swift

  'roles:haproxy':
    - match: grain
    - haproxy

  'roles:graphite':
    - match: grain
    - graphite

  'roles:statsd':
    - match: grain
    - statsd

  'roles:swift-proxy':
    - match: grain
    - swift.memcached
    - swift.proxy
