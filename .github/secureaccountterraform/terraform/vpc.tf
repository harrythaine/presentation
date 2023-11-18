#############################################################################################################################################
# VPC
#############################################################################################################################################
resource "aws_vpc" "VPC" {

  cidr_block = "${var.VPC_Cidr}"
  tags = {
    Name               = "${var.VPC_Name}"
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "infrastructure"
  }
}
#############################################################################################################################################
# public subnets in london
#############################################################################################################################################

resource "aws_subnet" "lon-pub-az1" {
  vpc_id            = "${aws_vpc.VPC.id}"
  cidr_block        = "${var.VPC_Cidr_lon_pub_az1}"
  availability_zone = "eu-west-1a"
  tags = {
    Name               = "${var.VPC_Cidr_lon_pub_SN_az1_Name}"
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "infrastructure"
  }
}

resource "aws_subnet" "lon-pub-az2" {
  vpc_id            = "${aws_vpc.VPC.id}"
  cidr_block        = "${var.VPC_Cidr_lon_pub_az2}"
  availability_zone = "eu-west-1b"
  tags = {
    Name               = "${var.VPC_Cidr_lon_pub_SN_az2_Name}"
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "infrastructure"
  }
}

#############################################################################################################################################
# priv subnets in london
#############################################################################################################################################
resource "aws_subnet" "lon-priv-az1" {
  vpc_id            = "${aws_vpc.VPC.id}"
  cidr_block        = "${var.VPC_Cidr_lon_priv_az1}"
  availability_zone = "eu-west-1a"
  tags = {
    Name               = "${var.VPC_Cidr_lon_priv_SN_az1_Name}"
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "infrastructure"
  }
}

resource "aws_subnet" "lon-priv-az2" {
  vpc_id            = "${aws_vpc.VPC.id}"
  cidr_block        = "${var.VPC_Cidr_lon_priv_az2}"
  availability_zone = "eu-west-1b"
  tags = {
    Name               = "${var.VPC_Cidr_lon_priv_SN_az2_Name}"
    "environment"  = "${var.Environment}"
    "pillar"       = "${var.Pillar}"
    "product"      = "${var.Product}"
    "product:type" = "infrastructure"
  }
}

resource "aws_flow_log" "vpc_flowlog_lon" {

  log_destination      = "${aws_cloudwatch_log_group.yada.arn}"
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  iam_role_arn         = "${aws_iam_role.all_vpc_flowlogs_role.arn}"
  vpc_id               = "${aws_vpc.VPC.id}"


}




# Create a route table for Requester
resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.VPC.id}"
  tags = {
    Name = "RT-VPC-INFOSEC-PRIVATE"
  }
}

