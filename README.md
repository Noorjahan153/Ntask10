**🚀 Blue / Green Deployment — Strapi on AWS (Fargate + ALB + CodeDeploy)**

This project demonstrates Blue-Green deployment of a Strapi CMS application on AWS using:

* Amazon ECS with Fargate Launch Type
* Application Load Balancer (ALB)
* AWS CodeDeploy for deployment automation
* Terraform for Infrastructure as Code
* Docker for containerization

The goal is to achieve zero-downtime deployment using traffic switching between Blue and Green environments.

🛠 Technologies Used

* Strapi CMS
* AWS ECS Fargate
* AWS ALB
* AWS CodeDeploy
* Terraform
* Docker
* GitHub

⚙ Prerequisites

* AWS Account
* Terraform Installed
* AWS CLI Configured
* Docker Installed
* GitHub Repository

🔐 Environment Variables

HOST=0.0.0.0
PORT=1337

APP_KEYS=key1,key2,key3,key4
API_TOKEN_SALT=salt123
ADMIN_JWT_SECRET=jwtsecret123
JWT_SECRET=jwtsecret123

**Commands I Used**

//git clone <repository-url>
cd strapi-ecs-prod
git add .
git commit -m "Initial deployment setup"
git push origin main//








