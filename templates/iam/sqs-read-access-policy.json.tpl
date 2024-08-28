{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "sqs:GetQueueUrl",
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage"
        ],
        "Resource": ${jsonencode(queue_arns)}
      }
    ]
}