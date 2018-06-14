resource "aws_security_group" "public_access" {
  name        = "${var.environment}-consul-public-access"
  description = "Access to LB from the Internet"
  vpc_id      = "${aws_vpc.main-vpc.id}"
  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-consul-public-access"
  }
}

# Cluster

resource "aws_security_group" "consul_cluster_lan" {
  name        = "${var.environment}-consul-cluster-lan"
  description = "Consul web access"
  vpc_id      = "${aws_vpc.main-vpc.id}"
  ingress {
    from_port = 8300
    to_port   = 8300
    protocol  = "tcp"
    self      = true
  }
  ingress {
    from_port = 8301
    to_port   = 8301
    protocol  = "tcp"
    self      = true
  }
  ingress {
    from_port = 8301
    to_port   = 8301
    protocol  = "udp"
    self      = true
  }
  ingress {
    from_port = 8500
    to_port   = 8500
    protocol  = "tcp"
    self      = true
  }
  egress {
    from_port = 8300
    to_port   = 8300
    protocol  = "tcp"
    self      = true
  }
  egress {
    from_port = 8301
    to_port   = 8301
    protocol  = "tcp"
    self      = true
  }
  egress {
    from_port = 8301
    to_port   = 8301
    protocol  = "udp"
    self      = true
  }
  egress {
    from_port = 8500
    to_port   = 8500
    protocol  = "tcp"
    self      = true
  }
  tags = {
    Name = "${var.environment}-consul-cluster-lan"
  }
}

resource "aws_security_group" "consul_cluster_wan" {
  name        = "${var.environment}-consul-cluster-wan"
  description = "Consul cluster wan communication"
  vpc_id      = "${aws_vpc.main-vpc.id}"
  ingress {
    from_port = 8302
    to_port   = 8302
    protocol  = "tcp"
    self      = true
  }
  ingress {
    from_port = 8302
    to_port   = 8302
    protocol  = "udp"
    self      = true
  }
  egress {
    from_port = 8302
    to_port   = 8302
    protocol  = "tcp"
    self      = true
  }
  egress {
    from_port = 8302
    to_port   = 8302
    protocol  = "udp"
    self      = true
  }
  tags = {
    Name = "${var.environment}-consul-cluster-wan"
  }
}