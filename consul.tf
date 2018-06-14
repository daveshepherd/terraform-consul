data "aws_ami" "consul" {
  most_recent = true

  filter {
    name   = "name"
    values = ["public-consul-${var.consul_version}*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["238573916854"]
}

resource "aws_iam_role" "consul_discovery" {
  name = "${var.environment}-consul_self_discovery"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid"      : "1",
      "Effect"   : "Allow",
      "Action"   : "sts:AssumeRole",
      "Principal": { "Service": "ec2.amazonaws.com" }
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "consul_discovery" {
  name = "${var.environment}-consul_self_discovery"
  role = "${aws_iam_role.consul_discovery.name}"
}

resource "aws_iam_role_policy" "consul_discovery" {
  role   = "${aws_iam_role.consul_discovery.id}"
  name   = "routing"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_launch_configuration" "consul" {
  name_prefix                 = "${var.environment}-"
  image_id                    = "${data.aws_ami.consul.id}"
  instance_type               = "t2.micro"
  iam_instance_profile        = "${aws_iam_instance_profile.consul_discovery.name}"
  key_name                    = "${var.key_name}"
  user_data                   = "${data.template_cloudinit_config.config.rendered}"
  associate_public_ip_address = true
  security_groups             = [
    "${aws_security_group.consul_cluster_wan.id}",
    "${aws_security_group.consul_cluster_lan.id}",
    "${aws_security_group.public_access.id}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "consul" {
  name                 = "${var.environment}-consul"
  min_size             = "${var.consul_cluster_size}"
  desired_capacity     = "${var.consul_cluster_size}"
  max_size             = "${var.consul_cluster_size}"
  launch_configuration = "${aws_launch_configuration.consul.name}"
  vpc_zone_identifier  = [ "${aws_subnet.consul.id}" ]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "consul"
    value               = "${var.environment}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "${var.environment}-consul"
    propagate_at_launch = true
  }
}