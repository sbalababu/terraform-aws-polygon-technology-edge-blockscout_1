data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["679593333241"]
  filter {
    name   = "name"
    values = [var.image_name]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "sg_lb" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "4.16.0"
  name                = "RPC-lb"
  description         = "SG for RPC lb"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
}

module "sg_internal" {
  source             = "terraform-aws-modules/security-group/aws"
  version            = "4.16.0"
  name               = "RPC-internal"
  description        = "SG for RPC app"
  vpc_id             = var.vpc_id
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
  ingress_with_source_security_group_id = [
    {
      from_port                = 4000
      to_port                  = 4000
      protocol                 = "tcp"
      description              = "RPC port"
      source_security_group_id = module.sg_lb.security_group_id
    },
  ]
}

data "cloudinit_config" "RPC" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content = templatefile(
      "${path.module}/templates/polygon_edge_server.tftpl",
      {
        "polygon_edge_dir"   = var.polygon_edge_dir
        "s3_bucket_name"     = var.s3_bucket_name
        "prometheus_address" = var.prometheus_address
        "block_gas_target"   = var.block_gas_target
        "nat_address"        = var.nat_address
        "dns_name"           = var.dns_name
        "price_limit"        = var.price_limit
        "max_slots"          = var.max_slots
        "block_time"         = var.block_time
      }
    )
  }

}

module "ec2_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "4.2.1"
  name                        = var.ec2_instance_name
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.ec2_instance_type
  monitoring                  = false
  vpc_security_group_ids      = concat([module.sg_internal.security_group_id], var.vpc_sgs)
  subnet_id                   = var.subnet_id
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  tags                        = var.tags
  user_data_base64            = data.cloudinit_config.RPC.rendered
  user_data_replace_on_change = true
}


