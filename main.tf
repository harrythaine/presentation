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
  region  = "eu-west-2"


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
module "lex_bot" {
  source        = "./chatbotterraform/lex"
  bot_name      = "MyChatbot"
  lambda_arn    = module.lambda.lambda_arn
  # Add other configuration options as needed
}

module "lambda" {
  source = "./chatbotterraform/lambda"
  # Add Lambda configuration options as needed
}

module "ecs" {
  source = "./chatbotterraform/ecs"
  # Add ECS configuration options as needed
}

module "ec2" {
  source = "./chatbotterraform/ec2"
  # Add ECS configuration options as needed
}