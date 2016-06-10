Swift Vagrant
=============

OpenStack Object Storage (swift) setup for Vagrant using multiple VMs.

The goal of this project is to create an environment that better mimics how a production setup might be, while still trying to remain small/simple.

By default, the environment will contain:

* 1 Load Balancer
* 1 Admin node
* 2 Proxy nodes (w/ memcache)
* 4 Storage nodes (w/ account/container/object)

Since this creates multiple VMs, it is recommended you use a system with plenty of resources.   I am using a Intel i7 with 16 GB of RAM.

Setup
-----

Copy the example config to local.yaml and modify to your liking.

```shell
$ cp example.local.yaml local.yaml
```

Now run Vagrant
```shell
$ vagrant up
Bringing machine 'lb1' up with 'virtualbox' provider...
Bringing machine 'proxy-z1' up with 'virtualbox' provider...
Bringing machine 'proxy-z2' up with 'virtualbox' provider...
Bringing machine 'storage-z1' up with 'virtualbox' provider...
Bringing machine 'storage-z2' up with 'virtualbox' provider...
Bringing machine 'storage-z3' up with 'virtualbox' provider...
Bringing machine 'storage-z4' up with 'virtualbox' provider...
...
```

Remaining Work
--------------

* TODO: Get initial environment running.
* TODO: Add option to run hummingbird.
* TODO: Add keystone node for authentication.
* TODO: Add (optional) graphite node.
* TODO: Add (optional) horizon node.
