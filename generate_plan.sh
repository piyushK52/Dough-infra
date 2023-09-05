terraform plan -out tf.plan
terraform show -no-color tf.plan > tfplan.txt
rm tf.plan