Saltstack for a multi-node Openstack Swift cluster
==================================================

This salt environment makes the following assumptions:

- Any servers killed individually have salt key manually removed after destroy
- There is one admin server.
- There is only one server with role `statsd`
- There is only one server with role `graphite`
- There is only one server with role `carbon`
- There is only one load balancer server
- Proxy servers are named `proxy-z1`, `proxy-z2` etc.
- Storage is named `storage-z1`, `storage-z2` etc.
- No support for multiple nodes per zone
- All pillar variables with `change` in value have been changed

Using the vagrant environment will produce a suitable small swift cluster.
Once all hosts are online and respond to salt commands, issue a `state.highstate` command to configure the cluster.

```
vagrant@admin1:~$ sudo salt '*' test.ping --out=txt
storage-z1: True
storage-z2: True
storage-z3: True
storage-z4: True
lb1: True
proxy-z1: True
proxy-z2: True
admin1: True
vagrant@admin1:~$ sudo salt '*' state.highstate
```

Using the default vagrant configuration shown above will produce a cluster with the following characteristics and services.

- admin1
  - salt master server
  - statsd, carbon-relay and graphite services
  - centralised syslog-ng logging
  - system metrics to graphite under servers.

- proxy-z1, proxy-z2
  - memcached running
  - swift-proxy-server running
  - swift-proxy logging to admin1
  - swift memcache.conf configured with proxy-z1 and proxy-z2
  - system metrics to graphite under servers.

- lb1
  - haproxy configured proxy-z1, proxy-z2 backend
  - haproxy logging to local4
  - haproxy http frontend only
  - system metrics to graphite under servers.


## Roles

These are defined in the salt grain `roles`. To see a servers defined roles or target servers by role use these commands. Available roles are listed.

```
vagrant@admin1:~$ sudo salt 'proxy-z1' grains.item roles
proxy-z1:
    ----------
    roles:
        - swift
        - swift-proxy
        - memcached
        - hourly_logs
vagrant@admin1:~$
vagrant@admin1:~$ sudo salt -G 'roles:memcached' test.ping --out=txt
proxy-z1: True
proxy-z2: True
vagrant@admin1:~$
vagrant@admin1:~$ sudo salt -C '* not G@roles:memcached' test.ping --out=txt
storage-z1: True
lb1: True
admin1: True
vagrant@admin1:~$
vagrant@admin1:~$ sudo salt -C 'G@roles:memcached not *z1' test.ping --out=txt
proxy-z2: True
vagrant@admin1:~$
```

      Roles      | Role Info
-----------------|---------------------------------------------------
swift            | installs swift code and dependencies
swift-object     | enables python swift obj server
swift-container  | enables container server
swift-account    | enables account server
swift-proxy      | enables proxy server, adds to haproxy backend
memcached        | enables memcached, adds to swift memcached config
haproxy          | enables haproxy
admin            | admin server for making rings, running recon etc.
saltmaster       | salt master
syslog           | configures syslog for remote hosts
statsd           | enables statsd server
carbon           | enables carbon relay
graphite         | configures graphiteweb
hourly_logs      | enables /var/log/swift/hourly logging

