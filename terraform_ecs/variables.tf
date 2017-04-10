variable "access_key" {}

variable "secret_key" {}

variable "microservice_name" {
  default = "rdawebserver"
}

variable "imagename" {}

variable "region" {
  default = "eu-west-1"
}

variable "az" {
  default = {
    "zone1" = "eu-west-1a"
    "zone2" = "eu-west-1b"
  }
}

/**
 * HVM NAT AMI for US-EAST-1
 * Created: October 29, 2016 at 6:26:48 AM UTC+5:30
 */
variable "nat_ami" {
  default = "ami-47ecb121"
}

/**
 * ECS Optimized AMI for EU-EAST-1
 * Version: 2016.09.c
 */
variable "ecs_ami" {
  default = "ami-95f8d2f3"
}

variable "ecs_instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = ""
}

variable "vpc_cidr" {
  default = "10.0.0.0/23"
}

variable "iam_ecs_instance" {}

variable "iam_ecs_service" {}

variable "sg_microservice_ecs" {}

variable "private_subnet_ids" {}

variable "alb_rdaes" {}

variable "health_check_grace_period" {
    default = "300"
    description = "Time after instance comes into service before checking health"
}

variable "availability_zones" {}

variable "efs_esdata_id" {}