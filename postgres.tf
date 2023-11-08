locals {
  postgres_identifier    = "mydbinstance"
  postgres_port          = 5432
}

resource "aws_security_group" "postgres_db_sg" {
  name = "postgres_db_sg"

  ingress {
    from_port   = local.postgres_port
    to_port     = local.postgres_port
    protocol    = "tcp"
    description = "PostgreSQL"
    cidr_blocks = ["0.0.0.0/0"] // >
  }

  ingress {
    from_port        = local.postgres_port
    to_port          = local.postgres_port
    protocol         = "tcp"
    description      = "PostgreSQL"
    ipv6_cidr_blocks = ["::/0"] // >
  }
}

resource "aws_db_instance" "postgres_db" {
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "15.3"
  instance_class         = "db.t3.micro"
  identifier             = local.postgres_identifier
  username               = var.username
  password               = var.password
  publicly_accessible    = true
  parameter_group_name   = "default.postgres15"
  vpc_security_group_ids = [aws_security_group.postgres_db_sg.id]
  skip_final_snapshot    = true
}