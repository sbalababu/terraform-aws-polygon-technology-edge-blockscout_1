/*
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
*/
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
    content      = templatefile(
     "${path.module}/templates/polygon_edge_node.tftpl",
     #  file("C:\Users\manue\Downloads\terraform-aws-polygon-technology-edge-blockscout\modules\user-data\scripts\polygont_edge_node.tftpl"),
      {
        "polygon_edge_dir"     = var.polygon_edge_dir
        "ebs_device"           = var.ebs_device
        "node_name"            = var.node_name
        "assm_path"            = var.assm_path
        "assm_region"          = var.assm_region
        "total_nodes"          = var.total_nodes
        "s3_bucket_name"       = var.s3_bucket_name
        "s3_key_name"          = var.s3_key_name
        "lambda_function_name" = var.lambda_function_name

        "premine"             = var.premine
        "chain_name"          = var.chain_name
        "chain_id"            = var.chain_id
        "pos"                 = var.pos
        "epoch_size"          = var.epoch_size
        "block_gas_limit"     = var.block_gas_limit
        "max_validator_count" = var.max_validator_count
        "min_validator_count" = var.min_validator_count
        "consensus"           = var.consensus

  }

  )
}
  
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
	"node_name"            = var.node_name
        "assm_path"            = var.assm_path
        "assm_region"          = var.assm_region
        "total_nodes"          = var.total_nodes
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
    
##Added the below line based on the blockscout
  iam_instance_profile = var.instance_iam_role

#  create_iam_instance_profile = true
#  iam_role_description        = "IAM role for EC2 instance"
#  iam_role_policies = {
#    AdministratorAccess = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#  }
  tags                        = var.tags
  user_data_base64            = data.cloudinit_config.RPC.rendered
  user_data_replace_on_change = true
}


resource "aws_volume_attachment" "attach_chain_data" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.chain_data.id
  instance_id = module.ec2_instance.id
}

resource "aws_ebs_volume" "chain_data" {
 availability_zone = var.az
  size              = var.chain_data_ebs_volume_size
  encrypted         = true

  tags = {
    Name = var.chain_data_ebs_name_tag
  }
 
}
