resource "aws_codedeploy_app" "app" {
  name             = "strapi-app"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "dg" {

  app_name               = aws_codedeploy_app.app.name
  deployment_group_name  = "strapi-dg"

  service_role_arn = "arn:aws:iam::055013504553:role/codedeploy_role"

  ########################################
  # ⭐ MUST ADD THIS (Fix Your Error)
  ########################################

  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option  = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ########################################
  # ECS Service
  ########################################

  ecs_service {
    cluster_name = aws_ecs_cluster.cluster.name
    service_name = aws_ecs_service.service.name
  }

  ########################################
  # Load Balancer Routing
  ########################################

  load_balancer_info {

    target_group_pair_info {

      target_group {
        name = aws_lb_target_group.blue.name
      }

      target_group {
        name = aws_lb_target_group.green.name
      }

      prod_traffic_route {
        listener_arns = [aws_lb_listener.listener.arn]
      }

    }
  }
}