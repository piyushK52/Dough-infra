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
          "sqs:CreateQueue",
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes",
          "sqs:ListQueues",
          "sqs:SendMessage",
          "sqs:SendMessageBatch",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:DeleteMessageBatch",
          "sqs:PurgeQueue",
          "sqs:ChangeMessageVisibility",
          "sqs:ChangeMessageVisibilityBatch",
          "sqs:GetQueueAttributes"
        ],
        "Resource": ${jsonencode(queue_arns)}
      }
    ]
}