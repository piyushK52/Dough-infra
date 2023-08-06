{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3Access",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": ["arn:aws:s3:::banodoco-data-bucket", 
            "arn:aws:s3:::banodoco-data-bucket/*", 
            "arn:aws:s3:::banodoco-data-bucket-public", 
            "arn:aws:s3:::banodoco-data-bucket-public/*"]
        }
    ]
}