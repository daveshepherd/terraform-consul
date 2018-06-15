# Terraform Consul Example

Warning: This is not designed for production use.

This is an example of a consul cluster built in AMS using [terraform](https://www.terraform.io).

It will start a 3 member cluster that is self discovering, there is no need to configure anything once the servers have
been started.

## Prerequisites

In order to use this you will need an AWS account and appropriate AWS credentials, as detailed in the
[terraform AWS provider documentation](https://www.terraform.io/docs/providers/aws/index.html).

Running this project may incur charges.

## Create with terraform

This can be run out of the box, but you may wish to override some of the variables to avoid conflicts with other
infrastructure in you AWS account.

Initialise terraform:

```
$ terraform init
```

This project requires an [Amazon EC2 key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html).

Specify the key pair name when running terraform, this can be done by creating a `terraform.tfvar` file in this project
containing the variable name and value:

```
key_name = "my-key-pair-name"
```

Now apply the terraform project:

```
terraform apply
```

When you're finished playing remember to destroy your infrastructure:

```
terraform destroy
```

## Consul

Use the EC2 console to find the public IP addresses of the servers in your cluster.

You can ssh to any of the consul machines using their public IP, the username 'ubuntu' and the private key for the key
pair used above.

```
ssh -i ./id_rsa ubuntu@198.51.100.44
```

Using the consul CLI the members of the cluster can be listed:

```
$ consul members
Node              Address             Status  Type    Build  Protocol  DC                Segment
ip-192-168-1-127  192.168.1.127:8301  alive   server  1.0.6  2         terraform-consul  <all>
ip-192-168-1-136  192.168.1.136:8301  alive   server  1.0.6  2         terraform-consul  <all>
ip-192-168-1-144  192.168.1.144:8301  alive   server  1.0.6  2         terraform-consul  <all>
```

You can also access the UI using one of the nodes public IP addresses:

http://198.51.100.44:8500/ui/#/terraform-consul/nodes