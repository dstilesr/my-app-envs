resource "aws_iam_role" "db_stopper" {
  name        = "${var.project}-db-stopper-${var.region}"
  description = "Role For lambda function that stops inactive databases"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

data "aws_iam_policy_document" "db_stopper" {
  version = "2012-10-17"
  statement {
    sid    = "StopDatabases"
    effect = "Allow"
    actions = [
      "rds:ListTagsForResource",
      "rds:DescribeDBInstances",
      "rds:DescribeDBClusters",
      "rds:StopDBCluster",
      "rds:StopDBInstance",
    ]
    resources = [
      "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:cluster:*",
      "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:db:*",
    ]
  }
}

resource "aws_iam_policy" "db_stopper" {
  name   = "${var.project}-db-stopper-${var.region}"
  policy = data.aws_iam_policy_document.db_stopper.json
}

resource "aws_iam_role_policy_attachment" "db_stopper" {
  policy_arn = aws_iam_policy.db_stopper.arn
  role       = aws_iam_role.db_stopper.name
}

