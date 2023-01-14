variable "docker_compose_values" {
  type = object({
    postgres_password             = string
    postgres_user                 = string
    postgres_host                 = string
    blockscout_docker_image       = string
    rpc_address                   = string
    chain_id                      = string
    rust_verification_service_url = string
  })
  default = {
    blockscout_docker_image       = "blockscout/blockscout-polygon-supernets:4.1.8-prerelease-651fbf3e"
    postgres_host                 = "postgres"
    postgres_password             = "postgres"
    postgres_user                 = "postgres"
    rpc_address                   = "http://localhost:9632"
    chain_id                      = "93201"
    rust_verification_service_url = "https://sc-verifier.aws-k8s.blockscout.com/"
  }
  description = "Values for docker-compose generation"
}

variable "path_docker_compose_files" {
  type        = string
  default     = "/opt/blockscout"
  description = "Path for blockscout files"
}

variable "user" {
  description = "What user to service run as"
  type        = string
  default     = "root"
}

variable "ec2_instance_name" {
  type        = string
  default     = "airflow"
  description = "Name of ec2 instance"
}

variable "ec2_instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Type of aws ec2 instance"
}

variable "image_name" {
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  description = "OS Image"
}

variable "vpc_sgs" {
  type        = any
  default     = []
  description = "Extended sgs to attach ec2 instance"
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "Subnet id where will create ec2 instance"
}

variable "tags" {
  type        = any
  default     = {}
  description = "Tags"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "VPC id where will create required resources"
}

#Polygon server
/* variable "polygon_edge_dir" {
  type        = string
  description = "The directory to place all polygon-edge data and logs"
}*/
variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket that holds genesis.json."
}
variable "prometheus_address" {
  type        = string
  description = "Enable Prometheus API"
}
variable "block_gas_target" {
  type        = string
  description = "Sets the target block gas limit for the chain"
}
variable "nat_address" {
  type        = string
  description = "Sets the NAT address for the networking package"
}
variable "dns_name" {
  type        = string
  description = "Sets the DNS name for the network package"
}
variable "price_limit" {
  type        = string
  description = "Sets minimum gas price limit to enforce for acceptance into the pool"
}
variable "max_slots" {
  type        = string
  description = "Sets maximum slots in the pool"
}
variable "block_time" {
  type        = string
  description = "Set block production time in seconds"
}

variable "polygon_edge_dir" {
  default     = "/home/ubuntu/polygon"
  type        = string
  description = "The directory to place all polygon-edge data and logs"
}

variable "ebs_device" {
  default     = "/dev/nvme1n1"
  type        = string
  description = "The ebs device path. Defined when creating EBS volume."
}

variable "node_name" {
  type        = string
  description = "The name prefix that will be used to store secrets"
  default     = "node"
}

variable "assm_path" {
  type        = string
  description = "The SSM paramter path."
}

variable "assm_region" {
  type        = string
  description = "The region for AWS SSM service."
}

variable "total_nodes" {
  type        = string
  description = "The total number of validator nodes."
}

variable "s3_key_name" {
  type        = string
  description = "Name for the config file stored in S3"
}

variable "lambda_function_name" {
  type        = string
  description = "The name of the chain init Lambda function"
}

variable "premine" {
  type        = string
  description = "Premine the accounts with the specified ammount."
}

## genesis options
variable "chain_name" {
  type        = string
  description = "Set the name of chain"
}
variable "chain_id" {
  type        = string
  description = "Set the Chain ID"
}
variable "block_gas_limit" {
  type        = string
  description = "Set the block gas limit"
}

variable "pos" {
  type        = bool
  description = "Deploy with PoS consensus"
}

variable "epoch_size" {
  type        = string
  description = "Set the epoch size"
}

variable "max_validator_count" {
  type        = string
  description = "Maximum number of stakers able to join the validator set in a PoS consensus."
}
variable "min_validator_count" {
  type        = string
  description = "Minimum number of stakers needed to join the validator set in a PoS consensus."
}
variable "consensus" {
  type        = string
  description = "Sets the consensus protocol"
}

variable "chain_data_ebs_volume_size" {
  type        = number
  description = "The size of the chain data EBS volume. Default: 30"
}

variable "chain_data_ebs_name_tag" {
  type        = string
  description = "The name of the chain data EBS volume. Default: Polygon_Edge_chain_data_ebs_volume"
}
variable "az" {
  type        = string
  description = "The availability zone of the instance."
}

variable "ebs_root_name_tag" {
  type        = string
  description = "The name tag for the Polygon Edge instance root volume."
}

variable "internal_sec_groups" {
  type        = list(string)
  description = "The list of security groups to attach to the instance."
}

variable "instance_iam_role" {
  type        = string
  description = "The IAM role to attach to the instance"
}
