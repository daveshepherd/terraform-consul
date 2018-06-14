data "template_file" "script" {
  template = "${file("${path.module}/server.json.tpl")}"
  vars {
    datacenter     = "${var.environment}"
    tag_value      = "${var.environment}"
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config
write_files:
- content: |
    ${base64encode(data.template_file.script.rendered)}
  encoding: b64
  owner: consul:consul
  path: /etc/consul.d/server.json
  permissions: '0400'
runcmd:
  - [ systemctl, enable, consul ]
  - [ systemctl, start, consul ]
EOF
  }
}