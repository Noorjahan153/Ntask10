resource "aws_codedeploy_app" "noor_app" {
  name             = "noor-app"
  compute_platform = "ECS"
}
resource "aws_codedeploy_deployment_group" "noor_dg" {
  app_name              = aws_codedeploy_app.noor_app.name
  deployment_group_name = "noor-dg"
  service_role_arn      = "arn:aws:iam::811738710312:role/CodeDeployRole"

  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.noor_cluster.name
    service_name = aws_ecs_service.noor_service.name
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
}