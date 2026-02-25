############################################
# CodeDeploy Application
############################################

resource "aws_codedeploy_app" "noor_app" {
  name             = "noor-app"
  compute_platform = "ECS"
}

############################################
# CodeDeploy Deployment Group
############################################

resource "aws_codedeploy_deployment_group" "noor_dg" {

  app_name              = aws_codedeploy_app.noor_app.name
  deployment_group_name = "noor-dg"

  # ✅ Use Existing CodeDeploy Role (Provided by Company)
  service_role_arn = "arn:aws:iam::811738710312:role/codedeploy_role"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.noor_cluster.name
    service_name  = aws_ecs_service.noor_service.name
  }

  load_balancer_info {

    target_group_pair_info {

      target_group {
        name = aws_lb_target_group.noor_blue_tg.name
      }

      target_group {
        name = aws_lb_target_group.noor_green_tg.name
      }

      prod_traffic_route {
        listener_arns = [aws_lb_listener.noor_listener.arn]
      }
    }
  }

  blue_green_deployment_config {

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }
}