{
    "Version": "2012-10-17",
    "Id": "AWSConsole-AccessLogs-Policy-${uuid}",
    "Statement": [
      {
        "Sid": "AWSConsoleStmt-${uuid}",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${logging_account_id}:root"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::${bucket_name}/AWSLogs/${aws_account_no}/*"
      }
    ]
  }