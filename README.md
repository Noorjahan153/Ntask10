**🚀 Blue / Green Deployment — Strapi on AWS (Fargate + ALB + CodeDeploy)**

This project demonstrates Blue-Green deployment of a Strapi CMS application on AWS using:

* Amazon ECS with Fargate Launch Type
* Application Load Balancer (ALB)
* AWS CodeDeploy for deployment automation
* Terraform for Infrastructure as Code
* Docker for containerization

The goal is to achieve zero-downtime deployment using traffic switching between Blue and Green environments.

**🛠 Technologies Used**

* Strapi CMS
* AWS ECS Fargate
* AWS ALB
* AWS CodeDeploy
* Terraform
* Docker
* GitHub

**⚙ Prerequisites**

* AWS Account
* Terraform Installed
* AWS CLI Configured
* Docker Installed
* GitHub Repository

**Commands I Used**

* git clone <repository-url>
* cd strapi-ecs-prod
* git add .
* git commit -m "Initial deployment setup"
* git push origin main
* followed github actions and terraform commands and ecs commands .

**🔁 Blue-Green Deployment Knowledge**

Blue-Green deployment is a strategy used to reduce downtime and deployment risks.

In this project:

* Blue Environment → Current production version of Strapi
* Green Environment → New application version being tested

  Traffic is routed using:

* Application Load Balancer
* AWS CodeDeploy deployment configuration

  Deployment Strategy Used:

* CodeDeployDefault.ECSCanary10Percent5Minutes
* Automatic rollback enabled for failed deployments

This ensures:

* Zero downtime deployment
* Safer release management
* Easy rollback if issues occur

 **🎯 Conclusion**

Through this project, I gained practical experience in cloud infrastructure deployment and modern DevOps practices. I learned how to deploy a containerized Strapi CMS application on AWS using Infrastructure as Code and Blue-Green deployment strategy to achieve zero-downtime releases.

I also understood how different AWS services work together in real-world production environments. While working on this project, I faced challenges such as 502 Bad Gateway errors, which helped me learn how to debug container networking, load balancer health checks, and security group configurations.

Thank you.


  
  








