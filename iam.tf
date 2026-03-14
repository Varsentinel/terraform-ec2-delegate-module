data "aws_iam_policy" "ssm_managed_instance_core" {
  name = "AmazonSSMManagedInstanceCore"
}
data "aws_iam_policy" "ssm_patch_association" {
  name = "AmazonSSMPatchAssociation"
}
resource "aws_iam_role" "this" {
  name = "${var.name}-ssm"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.ssm_managed_instance_core.arn
}

resource "aws_iam_role_policy_attachment" "ssm_patch_association" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.ssm_patch_association.arn
}


resource "aws_iam_instance_profile" "this" {
  name = var.name
  role = aws_iam_role.this.name
}