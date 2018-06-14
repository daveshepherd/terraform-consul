{
  "server": true,
  "datacenter": "${datacenter}",
  "bootstrap_expect": 3,
  "retry_join": ["provider=aws tag_key=consul tag_value=${tag_value}"],
  "data_dir": "/var/consul",
  "bind_addr": "0.0.0.0",
  "client_addr": "0.0.0.0",
  "ui": true,
  "log_level": "INFO",
  "enable_syslog": true
}