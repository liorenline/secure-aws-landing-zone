resource "aws_security_group" "app-sg" {
  name        = "app-sg"
  description = "app-sg"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "web-internal-sg"
  }
}

resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "db-sg"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.app-sg.id
  cidr_ipv4         = aws_vpc.myvpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_ingress_rule" "allow_inb" {
  security_group_id            = aws_security_group.db-sg.id
  referenced_security_group_id = aws_security_group.app-sg.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.app-sg.id
  cidr_ipv4         = aws_vpc.myvpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.app-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "endpoint" {
  name        = "endpoint"
  description = "endpoint"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "endpoint"
  }
}

resource "aws_vpc_security_group_egress_rule" "end" {
  security_group_id            = aws_security_group.endpoint.id
  referenced_security_group_id = aws_security_group.app-sg.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
}


