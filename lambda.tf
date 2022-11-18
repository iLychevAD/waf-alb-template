resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/files/lambda.py"
  output_path = "${path.module}/files/lambda.zip"
}

resource "aws_lb_target_group" "echo" {
  name        = local.name
  target_type = "lambda"
}

resource "aws_lambda_permission" "with_lb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  principal     = "elasticloadbalancing.amazonaws.com"
  function_name = aws_lambda_function.echo.function_name
  source_arn    = aws_lb_target_group.echo.arn
}

resource "aws_lambda_function" "echo" {
  filename      = data.archive_file.lambda.output_path
  function_name = local.name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.echo"

  source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)

  runtime = "python3.8"
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
