# BlueGreen Bank API

A production-grade mock financial transaction API demonstrating zero-downtime
Blue-Green deployments on AWS using CodeDeploy, ECS Fargate, and Terraform.

## Overview

Financial services can't afford downtime during deployments. This project
simulates exactly that constraint — a live payment API that must stay available
during version updates. CodeDeploy shifts traffic gradually from the Blue (v1)
environment to Green (v2), with automatic rollback if error rates spike.

## Tech Stack

- **App** — Node.js 24, TypeScript, Express 5
- **Containers** — Docker multi-stage build, ECR with image scanning
- **Compute** — AWS ECS Fargate (private subnets, no public IP)
- **Networking** — VPC with VPC Endpoints (ECR, S3, CloudWatch Logs) — no NAT Gateway
- **Load Balancing** — ALB with dual listeners (prod :80, test :8080)
- **Deployments** — AWS CodeDeploy `ECSLinear10PercentEvery1Minutes`
- **IaC** — Terraform (modular structure, S3 remote state)
- **CI/CD** — GitHub Actions

## Deployment Flow

1. Push to `main` triggers GitHub Actions
2. Docker builds and pushes to ECR (tagged with commit SHA)
3. New ECS task definition revision registered with updated image
4. CodeDeploy deployment triggered via `appspec.json`
5. Traffic shifts 10% per minute from Blue → Green (full cutover: ~10 min)
6. CloudWatch monitors 5xx error rate — auto-rollback if threshold exceeded
7. Blue task set terminated 5 minutes after successful cutover

## Architectural Diagram
<img width="2549" height="1967" alt="bluegreen_bank_api_architecture" src="https://github.com/user-attachments/assets/5ebed729-2b42-4ccd-a00b-2c318b2a7ce6" />

## Key Architecture Decisions

**VPC Endpoints over NAT Gateway**
ECS tasks run in private subnets with no internet route. ECR, S3, and
CloudWatch traffic routes through VPC Interface/Gateway Endpoints, keeping
all AWS service traffic within AWS's private network. Cheaper than option than
NAT Gateway plus more secure.

**Multi-Stage Docker Build**
Stage 1 compiles TypeScript with all dev dependencies. Stage 2 copies only
the compiled `dist/` and installs production dependencies via
`npm ci --omit=dev`. TypeScript compiler, ts-node, and source files never
reach the final image.

**CodeDeploy `lifecycle { ignore_changes }`**
The ECS service's `task_definition` and `load_balancer` blocks are excluded
from Terraform drift detection post-deploy. Without this, every CodeDeploy
deployment would appear as drift in `terraform plan` and risk being reverted
on the next apply.

**Desired Count of 2**
Two ECS tasks across two AZs at all times. During Blue-Green deployment,
CodeDeploy runs Blue and Green task sets simultaneously — you never drop
below full capacity during the swap.

## How to Run Locally

```bash
# Clone and install
git clone https://github.com/mosetemi/bluegreen-bank-api.git
cd bluegreen-bank-api/app
nvm use          # requires Node 24 via .nvmrc
npm install

# Run v1 locally
docker build -t bluegreen-bank-api:v1 .
docker run -p 3000:3000 -e APP_VERSION=v1 -e DEPLOY_COLOR=blue bluegreen-bank-api:v1

# Test
curl http://localhost:3000/health
curl http://localhost:3000/transactions
```

## Provisioning Infrastructure

```bash
cd iac
terraform init
terraform plan
terraform apply
```

**Note** Requires AWS CLI configured with appropriate permissions.

## What I'd Do Differently at Scale

- **One NAT Gateway per AZ** for true high availability in production
  (single NAT Gateway is a cost-saving tradeoff acceptable for dev/staging)
- **Terraform Workspaces or Terragrunt** to manage dev/staging/prod environments
  from the same module set
- **AWS WAF** in front of the ALB for production financial workloads
- **Canary deployment config** (`ECSCanary10Percent5Minutes`) for faster
  initial validation before linear rollout

## Author

Temidayo Moses — [temimoses.com](https://temimoses.com) |
[github.com/mosetemi](https://github.com/mosetemi)
