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
    public_subnets      = ["subnet-0bd998df5ba13b0a3","subnet-06b66f3a85082bfb1","subnet-00c6534d40c01c1d5"]
    private_subnets = ["subnet-0c63f747f7be8fb77","subnet-085f46d75886f8f4f","subnet-030485322fe506c57"]
    availability_zones  = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
    cluster_name        = "rosa-dev-cluster"
    openshift_version   = "4.18.7"
    account_role_prefix = "ManagedOpenShift"
    operator_role_prefix = "ManagedOpenShift"
    replicas           = 1
    htpasswd_idp_name   = "dev-htpasswd"
    htpasswd_username   = "dev-htadmin" 

  }
}

deployment "openshift_rosa_dev2" {
  inputs = {
    aws_identity_token = identity_token.aws.jwt
    role_arn            = "arn:aws:iam::521614675974:role/tfstacks-role"
    region             = "ap-southeast-2"
    rhcs_token        = store.varset.openshift_rosa.rhcs_token
    aws_billing_account_id = "521614675974"
    cidr_block          = "10.1.0.0/16"
    public_subnets      = ["subnet-0bd998df5ba13b0a3","subnet-06b66f3a85082bfb1","subnet-00c6534d40c01c1d5"]
    private_subnets = ["subnet-0c63f747f7be8fb77","subnet-085f46d75886f8f4f","subnet-030485322fe506c57"]
    availability_zones  = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
    cluster_name        = "rosa-dev-cluster-2"
    openshift_version   = "4.18.7"
    account_role_prefix = "dev2OpenShift"
    operator_role_prefix = "dev2OpenShift"
    replicas           = 1
    htpasswd_idp_name   = "dev2-htpasswd"
    htpasswd_username   = "dev2-htadmin" 

  }
}

orchestrate "auto_approve" "safe_plans_dev" {
  check {
      # Only auto-approve in the development environment if no resources are being removed
      condition = context.plan.changes.remove == 0 && context.plan.deployment == deployment.openshift_rosa_dev
      reason = "Plan has ${context.plan.changes.remove} resources to be removed."
  }
}
