
resource "aws_scheduler_schedule" "db_stopper" {
  schedule_expression = var.lambda_kickoff_schedule
  name                = "${var.project}-lambda-schedule-${var.region}"

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:lambda:invoke"
    role_arn = aws_iam_role.schedule.arn

    input = jsonencode({
      FunctionName   = aws_lambda_function.db_stopper.arn
      InvocationType = "Event"
    })
  }

  flexible_time_window {
    mode = "OFF"
  }
}
