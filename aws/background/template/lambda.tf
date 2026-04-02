
resource "aws_lambda_function" "db_stopper" {
  function_name = "${var.project}-db-stopper"
  role          = aws_iam_role.db_stopper.arn
  runtime       = "provided.al2023"
  memory_size   = var.lambda_memory
  package_type  = "Zip"
  filename      = "../../../db-shutdown/bin/bootstrap.zip"
  handler       = "db-stopper"
}

