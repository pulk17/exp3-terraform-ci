# Experiment III - Continuous Integration for Infrastructure as Code

Terraform project driven by a Jenkins declarative pipeline: format check, validation,
lint, security scan, reviewable plan artefact, manual approval gate and apply.

| Field | Detail |
| --- | --- |
| Name | Pulkit Chauhan |
| SAP ID | 500121424 |
| Roll number | R2142230354 |
| Programme | B.Tech CSE (DevOps), UPES Dehradun |
| Course outcome | CO5 |

## Layout

    Jenkinsfile              declarative pipeline (Listing 3.1)
    .tflint.hcl              lint configuration (Listing 3.2)
    versions.tf              provider and version constraints
    variables.tf             input variables
    main.tf                  module composition
    outputs.tf               stack outputs
    modules/network/         VPC, subnets, gateway, route tables, security group
    modules/compute/         EC2 application host and elastic IP

`terraform apply` creates 11 resources in ap-south-1.
