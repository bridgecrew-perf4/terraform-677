resource "aws_s3_bucket" "production-bucket" {
  bucket = "app.theglew-io"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = [var.production_url]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}


resource "aws_s3_bucket" "develop-bucket" {
  bucket = "s3-website-test.hashicorp.com"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = [var.develop_url]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket" "staging-bucket" {
  bucket = "s3-website-test.hashicorp.com"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = [var.staging_url]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}