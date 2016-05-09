haproxy_ppa:
  pkgrepo.managed:
    - name: deb http://ppa.launchpad.net/vbernat/haproxy-1.5/ubuntu {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/haproxy_ppa.list
    - keyid: 505D97A41C61B9CD
    - keyserver: hkp://keyserver.ubuntu.com:80
    - refresh: True

haproxy_pkg:
  pkg:
    - name: haproxy
    - installed
    - force_yes: True
    - skip_verify: True

haproxy:
  apt:
    - held
    - require:
      - pkg: haproxy_pkg
