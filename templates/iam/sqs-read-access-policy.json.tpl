{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes",
          "sqs:ListQueues",
          "sqs:SendMessage",
          "sqs:SendMessageBatch",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:DeleteMessageBatch",
          "sqs:ChangeMessageVisibility",
          "sqs:ChangeMessageVisibilityBatch",
          "sqs:GetQueueAttributes"
        ],
        "Resource": ${jsonencode(queue_arns)}
      }
    ]
}