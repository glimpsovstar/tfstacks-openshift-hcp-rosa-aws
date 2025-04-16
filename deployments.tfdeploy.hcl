identity_token "aws" {
  audience = ["terraform-stacks-private-preview"]
}

store "varset" "openshift_rosa" {
  id       = "varset-Mm84KjHtQNWfoCJc"
  category = "terraform"
}


deployment "openshift_rosa_dev" {
  inputs = {
    aws_identity_token = identity_token.aws.jwt
    role_arn            = "arn:aws:iam::521614675974:role/tfstacks-role"
    region             = "ap-southeast-2"
    rhcs_token        = store.varset.openshift_rosa.rhcs_token
    aws_billing_account_id = "521614675974"
    cidr_block          = "10.1.0.0/16"
    public_subnets      = ["subnet-05fdfbb99d4786f03"]
    private_subnets = ["subnet-05fdfbb99d4786f03","subnet-08ef1a374e560fc44"]
    availability_zones  = ["ap-southeast-2a", "ap-southeast-2b"]
    cluster_name        = "rosa-dev-cluster"
    openshift_version   = "4.18.7"
    account_role_prefix = "ManagedOpenShift"
    operator_role_prefix = "ManagedOpenShift"
    replicas           = 1
    htpasswd_idp_name   = "dev-htpasswd"
    htpasswd_username   = "dev-htadmin" 

  }
}


orchestrate "auto_approve" "safe_plans_dev" {
  check {
      # Only auto-approve in the development environment if no resources are being removed
      condition = context.plan.changes.remove == 0 && context.plan.deployment == deployment.openshift_rosa_dev
      reason = "Plan has ${context.plan.changes.remove} resources to be removed."
  }
}
