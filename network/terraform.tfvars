###############
### General ###
###############
region = "europe-west3"
#org_id = "113360958233"

###########
### VPC ###
###########
vpc = {
  convrt-common = {
    vpc-common = {
      description  = "VPC for common project"
      routing_mode = "GLOBAL"
    }
  }

  convrt-dev = {
    vpc-dev = {
      description  = "VPC for dev project"
      routing_mode = "GLOBAL"
    }
  }

  preprod-423309 = {
    vpc-preprod = {
      description  = "VPC for preprod project"
      routing_mode = "GLOBAL"
    }
  }

  convrt-prod = {
    vpc-prod = {
      description  = "VPC for Prod project"
      routing_mode = "GLOBAL"
    }
  }
}

#######################
### Hub Spoke (VPN) ###
#######################
vpn_mgmt_dev = {
  mgmt_project_id = "convrt-common"
  dev_project_id  = "convrt-dev"
  dev_network     = "vpc-dev"
  mgmt_network    = "vpc-common"
}

vpn_mgmt_preprod = {
  mgmt_project_id    = "convrt-common"
  preprod_project_id = "preprod-423309"
  preprod_network    = "vpc-preprod"
  mgmt_network       = "vpc-common"
}

vpn_mgmt_prod = {
  mgmt_project_id = "convrt-common"
  prod_project_id = "convrt-prod"
  prod_network    = "vpc-prod"
  mgmt_network    = "vpc-common"
}

###########
### NAT ###
###########
nat = {
  convrt-common = {
    nat-vpc-common-euw3 = {
      network                 = "vpc-common"
      router                  = "cr-nat-vpc-common-euw3"
      number_static_addresses = 1
    }
  }

  convrt-dev = {
    nat-vpc-dev-euw3 = {
      network                 = "vpc-dev"
      router                  = "cr-nat-vpc-dev-euw3"
      number_static_addresses = 1
    }
  }

  preprod-423309 = {
    nat-vpc-preprod-euw3 = {
      network                 = "vpc-preprod"
      router                  = "cr-nat-vpc-preprod-euw3"
      number_static_addresses = 1
    }
  }

  convrt-prod = {
    nat-vpc-prod-euw3 = {
      network                 = "vpc-prod"
      router                  = "cr-nat-vpc-prod-euw3"
      number_static_addresses = 1
    }
  }
}

###############
### Subnets ###
###############
subnets = {
  convrt-common = {
    vpc-common = [
      {
        subnet_name = "sb-vpc-common-euw3"
        subnet_ip   = "10.0.0.0/20"
        description = "Subnet for mgmt services"
      }
    ]
  }

  convrt-dev = {
    vpc-dev = [
      {
        subnet_name = "sb-vpc-dev-euw3"
        subnet_ip   = "10.1.0.0/20"
        description = "Subnet for dev services"
      }
    ]
  }

  preprod-423309 = {
    vpc-preprod = [
      {
        subnet_name = "sb-vpc-preprod-euw3"
        subnet_ip   = "10.2.0.0/20"
        description = "Subnet for preprod services"
      }
    ]
  }
  convrt-prod = {
    vpc-prod = [
      {
        subnet_name = "sb-vpc-prod-euw3"
        subnet_ip   = "10.3.0.0/20"
        description = "Subnet for prod services"
      }
    ]
  }
}


##############################################
### Private Service Access (For Cloud SQL) ###
##############################################
private_service_access = {
  convrt-common = {
    vpc-common = "10.100.0.0/24"
  }
  convrt-dev = {
    vpc-dev = "10.101.0.0/24"
  }
  preprod-423309 = {
    vpc-preprod = "10.102.0.0/24"
  }
  convrt-prod = {
    vpc-prod = "10.103.0.0/24"
  }
}

