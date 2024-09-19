# -------------- defining SQS queues ---------------------------------
variable "queue_names" {
  type    = list(string)
  default = ["job_queue.fifo", "job_queue_1.fifo", "job_queue_2.fifo", "output_queue.fifo"]
}

resource "aws_sqs_queue" "fifo_queues" {
  count                       = length(var.queue_names)
  name                        = var.queue_names[count.index]
  fifo_queue                  = true
  content_based_deduplication = true
}

# full sqs access to ec2 and ecs instances
resource "aws_sqs_queue_policy" "full_queue_access" {
  count     = length(aws_sqs_queue.fifo_queues)
  queue_url = aws_sqs_queue.fifo_queues[count.index].id

  policy = templatefile("./templates/iam/sqs-full-access-policy.json.tpl", {
    queue_arns    = aws_sqs_queue.fifo_queues[*].arn
  })
}


output "queue_urls" {
  value = { for idx, queue in aws_sqs_queue.fifo_queues : var.queue_names[idx] => queue.url }
}

# ----------------- IAM user to access this from the outside ---------------------
# read sqs access (NOTE: this is a iam_policy not a sqs_iam_policy)
resource "aws_iam_policy" "sqs_access_policy" {
  name        = "sqs-access-policy"
  description = "IAM policy for SQS access"

  policy = templatefile("./templates/iam/sqs-read-access-policy.json.tpl", {
    queue_arns = aws_sqs_queue.fifo_queues[*].arn
  })
}

resource "aws_iam_user" "sqs_user" {
  name = "sqs-access-user"
  path = "/system/"
}

resource "aws_iam_access_key" "sqs_user_key" {
  user = aws_iam_user.sqs_user.name
}

resource "aws_iam_user_policy_attachment" "sqs_access_attach" {
  user       = aws_iam_user.sqs_user.name
  policy_arn = aws_iam_policy.sqs_access_policy.arn
}

output "sqs_user_access_key_id" {
  value = aws_iam_access_key.sqs_user_key.id
}

output "sqs_user_secret_access_key" {
  value     = aws_iam_access_key.sqs_user_key.secret
  sensitive = true
}