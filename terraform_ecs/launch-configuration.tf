# User data template that specifies how to bootstrap each instance
data "template_file" "user_data" {
  template = "${file("${path.module}/files/user-data.tpl")}"

  vars {
    ecs_name = "${var.microservice_name}"
    efs_file_system_id = "${var.efs_esdata_id}"
  }
}

/**
 * Launch-configuration for ECS
 */
resource "aws_launch_configuration" "ecs" {
  name                 = "${var.microservice_name}-ecs"
  image_id             = "${var.ecs_ami}"
  instance_type        = "${var.ecs_instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = ["${var.sg_microservice_ecs}"]
  iam_instance_profile = "${var.iam_ecs_instance}"
  user_data            = "${data.template_file.user_data.rendered}"
}