swift_hash_path_suffix: change_this
swift_hash_path_prefix: and_change_this_too

swift_install_type: git
swift_object_server: python-swift

swift_git_install_branch: master
swift_pkg_install_type: repo
swift_pkg_repo_url: false
swift_pkg_download_url: false

swift:
  proxy:
    pipeline: informant catch_errors gatekeeper healthcheck proxy-logging cache bulk tempurl formpost swauth container-quotas ratelimit staticweb slo dlo proxy-logging proxy-server
    workers: 8
    trans_id_suffix: vagrant
    recoverable_node_timeout: 3
    node_timeout: 60
    conn_timeout: 3.5
    max_containers_whitelist: .expiring_objects
    account_whitelist: TEST
    allow_account_management: false
    account_autocreate: true
    strict_cors_mode: true
    request_node_count: 2 * replicas
    log_handoffs: true
    log_max_line_length: 8192
    max_containers_per_account: 50000
    account_ratelimit: 200000.0
    container_ratelimit: 100
    memcache_serialization_support: 2
    bulk_yield_frequency: 10
    tempurl_methods: GET HEAD PUT DELETE
    swauth_default_swift_cluster: "???"
    swauth_super_admin_key: change_me
    swauth_reseller_prefix: SWAUTH
    informant_statsd_sample_rate: 0.25
    informant_combined_events: yes
    healthcheck_disable_path: /etc/swift/proxy_disabled
