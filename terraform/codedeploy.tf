resource "aws_codedeploy_app" "noor_app" {
  name = "noor-strapi-codedeploy"
  compute_platform = "ECS"
}