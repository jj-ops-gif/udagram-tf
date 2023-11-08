resource "aws_s3_bucket" "udagram_bucket" {
  bucket = "test-133750217366-dev"
  force_destroy = true
  tags = {
    Name        = "test-133750217366-dev"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.udagram_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_access_from_k8s" {
  bucket = aws_s3_bucket.udagram_bucket.id
  # policy = data.aws_iam_policy_document.allow_access_from_k8s.json
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::test-133750217366-dev"
        },
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::test-133750217366-dev/*"
        }
    ]
}
EOF
}


# data "aws_iam_policy_document" "allow_access_from_k8s" {
#   statement {
#     effect = "Allow"
#     actions = [
#         "s3:ListBucket",
#     ]
    
#     principals {
#       type        = "Service"
#       identifiers = ["*"]
#     }
    
#     resources = [
#       aws_s3_bucket.udagram_bucket.arn,
#       "${aws_s3_bucket.udagram_bucket.arn}",
#     ]
#   }

#   statement {
#     effect = "Allow"
#     actions = [
#         "s3:PutObject",
#         "s3:GetObject",
#         "s3:DeleteObject"
#     ]
    
#     principals {
#       type        = "Service"
#       identifiers = ["*"]
#     }

#     resources = [
#       aws_s3_bucket.udagram_bucket.arn,
#       "${aws_s3_bucket.udagram_bucket.arn}/*",
#     ]
#   }
# }

resource "aws_s3_bucket_cors_configuration" "udagram_s3_cors" {
  bucket = aws_s3_bucket.udagram_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["POST", "GET", "PUT", "DELETE", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = []
  }

}

output "udagram_bucket_name" {
    value = aws_s3_bucket.udagram_bucket.id
}