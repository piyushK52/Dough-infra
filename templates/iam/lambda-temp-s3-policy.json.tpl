{
    "Version": "2012-10-17",

    "Statement": [
      {
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": [
          "arn:aws:s3:::banodoco-temp-data-bucket-public",
          "arn:aws:s3:::banodoco-temp-data-bucket-public/*"
        ]
      }
    ]
  }