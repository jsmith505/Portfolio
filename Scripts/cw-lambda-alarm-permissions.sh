aws lambda add-permission \
  --region <REPLACE WITH YOUR REGION> \
  --function-name AlarmsInvokeLambda \
  --statement-id AlarmInvokePermission \
  --action 'lambda:InvokeFunction' \
  --principal cloudwatch.amazonaws.com \
  --source-account <REPLACE WITH YOUR ACCOUNT> \
  --source-arn arn:aws:cloudwatch:<REPLACE WITH YOUR REGION>:<REPLACE WITH YOUR ACCOUNT>:alarm:*
