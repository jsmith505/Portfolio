aws cloudwatch put-metric-alarm --alarm-name "HighCPUUtilization" \
  --metric-name "CustomCPUUtilization" --namespace "Custom" \
  --statistic "Average" --period 300 --threshold 80 \
  --comparison-operator "GreaterThanThreshold" --evaluation-periods 2 \
  --alarm-actions "arn:aws:lambda:us-east-1:123456789012:function:MyLambdaFunction"
