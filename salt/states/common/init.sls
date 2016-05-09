common_pkgs:
  pkg:
    - installed
    - refresh: True
    - pkgs:
      - patch
      - curl
      - debconf
      - git
      - gcc
      - ethtool
      - strace
      - screen
      - tmux
      - python-pip
      - python-setuptools
      - python-netifaces
      - sqlite3
      - traceroute
      - python-dev
      - build-essential
      - libffi-dev
      - liberasurecode-dev
      - libssl-dev
      - openssl

common_pip:
  pip:
    - installed
    - reload_modules: True
    - upgrade: true
    - require:
      - pkg: common_pkgs
    - pkgs:
      - pip
      - gitdb
      - pyopenssl
      - ndg-httpsclient
      - pyasn1
