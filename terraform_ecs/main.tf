/**
 * AWS Region
 */
provider "aws" {
  region     = "${var.region}"
}

/**
 * Autoscale group for ECS
 */
resource "aws_autoscaling_group" "ecs" {
  name                 = "${var.microservice_name}-microservice"
  vpc_zone_identifier  = ["${split(",", var.private_subnet_ids)}"]
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  health_check_type    = "EC2"
  load_balancers       = ["${var.alb_rdaes}"]
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  health_check_grace_period = "${var.health_check_grace_period}"

  tag {
    key                 = "Name"
    value               = "${var.microservice_name}"
    propagate_at_launch = true
  }
}

/**
 * ECS Cluster
 */
resource "aws_ecs_cluster" "microservice" {
  name = "${var.microservice_name}"
}

/**
 * ECS Task definitions
 */
resource "aws_ecs_task_definition" "task" {
    family = "${var.microservice_name}"

    container_definitions = <<EOF
[
    {
        "cpu": 1024,
        "name": "${var.microservice_name}",
        "image": "${var.imagename}",
        "essential": true,
        "memory": 950,
        "environment" : [
            { "name" : "ES_HEAP_SIZE", "value" : "475m" }
        ],
        "command": [
            "elasticsearch",
            "-Des.discovery.type=ec2",
            "-Des.discovery.ec2.groups=${var.microservice_name}",
            "-Des.discovery.ec2.availability_zones=${var.availability_zones}",
            "-Des.cloud.aws.region=${var.region}"
        ],
        "MountPoints": [
            {
                "ContainerPath": "/usr/share/elasticsearch/data",
                "SourceVolume": "efs-es-data"
            }
        ],
        "portMappings": [
            {
                "containerPort": 9200,
                "hostPort": 9200
            },
            {
                "containerPort": 9300,
                "hostPort": 9300
            }
        ]
    }
]
EOF

    volume {
        name = "efs-es-data"
        host_path = "/mnt/efs"
    }
}


/**
 * ECS service creation
 */
resource "aws_ecs_service" "service" {
  name            = "${var.microservice_name}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  cluster         = "${aws_ecs_cluster.microservice.id}"
  desired_count   = 1
  iam_role        = "${var.iam_ecs_service}"

  load_balancer {
    elb_name       = "${var.alb_rdaes}"
    container_name = "${var.microservice_name}"
    container_port = 9200
  }
}