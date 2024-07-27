
resource "aws_iam_role" "ec2_s3_readonly" {
  name = "ec2_s3_readonly_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_readonly" {
  name        = "s3_readonly_policy"
  description = "S3 read-only access policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_readonly" {
  role       = aws_iam_role.ec2_s3_readonly.name
  policy_arn = aws_iam_policy.s3_readonly.arn
}

resource "aws_iam_instance_profile" "ec2_s3_readonly" {
  name = "ec2_s3_readonly"
  role = aws_iam_role.ec2_s3_readonly.name
}
