# Check AWS Secrets Manager: https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1

resource "aws_db_instance" "theglew" {
  allocated_storage         = 40
  storage_type              = "gp2"
  engine                    = "postgres"
  engine_version            = "12.4"
  instance_class            = "db.m6g.4xlarge"
  name                      = "postgres"
  username                  = "theglew"
  password                  = "theglew.io"
  skip_final_snapshot       =  true
  final_snapshot_identifier =  "prod-snapshot"
  identifier                = "theglew-database"
}