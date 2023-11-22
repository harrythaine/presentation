# Requlon TF version to most recent
/*
terraform {
  #requlond_version = "=1.6.4"
   backend "s3" {
    bucket         = "bucketname"
    key            = "state.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "dydbname"
    encrypt        = true
    
  }
}
*/
# Download any stable version in AWS provider of 2.19.0 or higher in 2.19 train
provider "aws" {
  region     = "eu-west-2"
  access_key = var.TF_VAR_AWS_ACCESS_KEY_ID  # This should reference your variable directly: var.AWS_ACCESS_KEY_ID
  secret_key = var.TF_VAR_AWS_SECRET_ACCESS_KEY  # Similar change here: var.AWS_SECRET_ACCESS_KEY
}

/*
module "secureaccountterraform" {
    source                                      = "./secureaccountterraform"
    #provider
    #IAM
    Account_Alias                               = "presentation test account"
    account_id                                  = ""
    Config-Role-Name                            = "Config-Role"
    #CloudTrail/ cloudwatch
    CloudTrail-S3-Name                          = "htbcloudtrailloggingbucket"
    CloudTrail-Trail                            = ""
    cloudtrail_log_group_name                   = "CloudTrail/DefaultLogGroup"
    alarm_namespace                             = ""
    sns_topic_name                              = "" 
    #VPC
    VPC_Cidr                          = ""
    VPC_Name                          = ""
    VPC_Cidr_lon_pub_az1              = ""
    VPC_Cidr_lon_pub_SN_az1_Name      = ""
    VPC_Cidr_lon_pub_az2              = ""
    VPC_Cidr_lon_pub_SN_az2_Name      = ""
    VPC_Cidr_lon_priv_az1             = ""
    VPC_Cidr_lon_priv_SN_az1_Name     = ""
    VPC_Cidr_lon_priv_az2             = ""
    VPC_Cidr_lon_priv_SN_az2_Name     = ""
    #tagging
    Environment                       = ""
    Pillar                            = ""
    Product                           = ""
}
*/


module "lambda" {
  source              = "./chatbotterraform/lambda"
/*  lambda_environment  = {
    lex_bot_name = module.lex_bot.lex_bot_name  # Check if lex_bot module is defined
    # Add other environment variables as needed
  }
*/  # Add other Lambda configuration options as needed
}

module "lex_bot" {
  source        = "./chatbotterraform/lex"
  lambda_arn    = module.lambda.lambda_arn  # Check if lambda module is defined
  # Add other configuration options as needed
}

module "ecs" {
  source = "./chatbotterraform/ecs"
  # Add ECS configuration options as needed
}

module "ec2" {
  source = "./chatbotterraform/ec2"
  # Add EC2 configuration options as needed
}

module "iam_role" {
  source = "./chatbotterraform/iam_role"
}

module "iam_role_policy" {
  source   = "./chatbotterraform/iam_role_policy"
  role_arn = module.iam_role.lambda_execution_role.arn
}