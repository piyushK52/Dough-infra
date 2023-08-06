data "aws_availability_zones" "avialable" {
    state = "available"
}

resource "aws_vpc" "main" {
    cidr_block = "172.32.0.0/16"
    enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "private" {
    count = var.az_count
    cidr_block = cidrsubnet("172.32.0.0/16", 8, count.index)    # 172.32.0.0/24 and 172.32.1.0/24
    availability_zone = data.aws_availability_zones.avialable.names[count.index]
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "Private subnet"
    }
}

resource "aws_subnet" "public" {
    count = var.az_count
    cidr_block = cidrsubnet("172.32.0.0/16", 8, var.az_count + count.index)     # 172.32.2.0/24 and 172.32.3.0/24
    availability_zone = data.aws_availability_zones.avialable.names[count.index]
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "Public subnet"
    }
}

resource "aws_route" "internet_access" {
    route_table_id = aws_vpc.main.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-south-1.s3"
  vpc_endpoint_type = "Gateway"

  auto_accept     = true
  route_table_ids = [aws_vpc.main.main_route_table_id]
}