include:
  - swift.base
  {% if pillar['swift_install_type'] == "git" %}
  - swift.git_install
  {% endif %}
