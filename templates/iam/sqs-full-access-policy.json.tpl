{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": [
            "ec2.amazonaws.com",
            "ecs-tasks.amazonaws.com"
          ]
        },
        "Action": [
          "sqs:GetQueueUrl",
          "sqs:CreateQueue",
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage"
        ],
        "Resource": ${jsonencode(queue_arns)}
      }
    ]
}