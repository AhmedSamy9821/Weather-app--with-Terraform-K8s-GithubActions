# Weather-app-with-Terraform-EKS-GithubActions

## Overview
This project is a weather application designed to fetch weather data for any city. It is built using microservices architecture and deployed on Kubernetes (EKS) using Terraform and GitHub Actions.

## Features
- **Microservices Architecture**: Consists of three services - UI, Auth, and Backend.
- **Stateful MySQL Database**: Uses StatefulSet controller to deploy MySQL, ensuring data persistence by attaching EBS volumes through volumeClaimTemplates.
- **Environment-Based Pipelines**: Supports development and production environments through parameterized pipelines.

## Components
### 1. Microservices
- **UI Service**: Frontend for user interaction.
- **Auth Service**: Handles user sign-up and sign-in, storing user data in the MySQL database.
- **Backend Service**: Fetches weather data based on user requests.

### 2. Database
- MySQL database deployed as a **StatefulSet**.
- Persistent data storage using **EBS volumes** attached via **volumeClaimTemplates**.

## Pipelines
This project uses GitHub Actions workflows to automate infrastructure provisioning, CI, and CD.

### 1. Infrastructure Pipeline
- **Purpose**: Builds the AWS infrastructure, including VPC, subnets, EKS cluster, node groups, add-ons, and IAM roles.
- **Domain Setup**: Creates certificates for the domain.
- **Environment-Based**: Allows build the production or development environments by selecting the environment from the Environment list.

### 2. CI Pipeline
- **Purpose**: Builds Docker images for the services (UI, Auth, Backend) and pushes them to Docker Hub.
- **Secrets Management**: Uses GitHub secrets for storing Docker credentials.

### 3. CD Pipeline
- **Purpose**:
  1. Installs the ingress controller on the EKS cluster.
  2. Pulls images from Docker Hub and deploys the services.
  3. Creates DNS records for the domain and attaches certificates to secure traffic using HTTPS.
- **Environment-Based**: Supports deployment to production or development environments by selecting the environment from the Environment list.


## Deployment Steps
1. Run the **Infrastructure Pipeline** to set up the infrastructure.
2. Run the **CI Pipeline** to build and push Docker images.
3. Run the **CD Pipeline** to deploy the services to the EKS cluster.

## Requirements
- AWS Account with access to create infrastructure resources.
- Docker and Docker Hub account for building and storing images.

## Conclusion
This project demonstrates a complete CI/CD pipeline for deploying a microservices-based weather application using Terraform, Kubernetes, and GitHub Actions. It supports environment-based deployments and ensures secure traffic encryption through domain certificates.

