# aws-bedrock-ami-healer-ssm

## What This Repo Does
Manages the SSM Parameter Store structure that glues all repos together.

This repo does NOT deploy application logic. It owns the SSM namespace,
documents what each parameter means, and provides a central place to
view, audit, and manage cross-repo configuration.

## SSM Parameter Map

```
/ami-healer/
├── infra/                          written by: aws-bedrock-ami-healer-infra
│   ├── asg-name                    read by: lambda, eventbridge
│   ├── launch-template-id          read by: lambda
│   ├── launch-template-name        read by: lambda
│   ├── alb-arn                     read by: lambda
│   ├── alb-dns                     read by: lambda
│   ├── vpc-id                      read by: lambda
│   ├── working-ami-id              read by: lambda (rollback)
│   ├── broken-ami-id               read by: lambda (diagnosis context)
│   └── target-group-arn            read by: lambda
│
├── bedrock/                        written by: aws-bedrock-ami-healer-bedrock
│   ├── model-id                    read by: lambda
│   └── prompt-template             read by: lambda
│
├── lambda/                         written by: aws-bedrock-ami-healer-lambda
│   ├── healer-arn                  read by: eventbridge
│   └── healer-name                 read by: eventbridge
│
└── pipeline/                       written by: lambda at runtime
    └── latest-analysis             audit trail of last Bedrock diagnosis
```

## What This Repo Deploys
- IAM policy document that grants read access to `/ami-healer/*` namespace
- CloudWatch dashboard to visualize all SSM parameters in one view
- SSM maintenance window for scheduled parameter audits

## Deploy Order
Deploy first — before any other repo except infra.

## GitHub Secrets Required
| Secret | Value |
|--------|-------|
| `AWS_ACCESS_KEY_ID` | IAM user access key |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key |
| `AWS_REGION` | `us-east-1` |
| `TF_STATE_BUCKET` | shared S3 bucket |
| `TF_STATE_LOCK_TABLE` | shared DynamoDB table |
