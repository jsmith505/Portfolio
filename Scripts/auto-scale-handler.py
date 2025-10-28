import boto3
import os

# AWS Clients
ec2_client = boto3.client('ec2')
cloudwatch_client = boto3.client('cloudwatch')
autoscaling_client = boto3.client('autoscaling')

# Configurations
INSTANCE_ID = os.environ.get('INSTANCE_ID')  # EC2 Instance ID to scale
ALARM_NAME = 'HighCPUUsageAlarm'
AUTO_SCALING_GROUP_NAME = os.environ.get('AUTO_SCALING_GROUP_NAME')  # Auto Scaling Group Name
CPU_THRESHOLD = 80  # CPU Usage threshold for scaling

# Function to create CloudWatch alarm based on CPU usage
def create_cpu_alarm():
    response = cloudwatch_client.put_metric_alarm(
        AlarmName=ALARM_NAME,
        ComparisonOperator='GreaterThanThreshold',
        EvaluationPeriods=1,
        MetricName='CPUUtilization',
        Namespace='AWS/EC2',
        Period=300,
        Statistic='Average',
        Threshold=CPU_THRESHOLD,
        ActionsEnabled=True,
        AlarmActions=[
            # Replace with SNS Topic ARN or Auto Scaling action
        ],
        Dimensions=[
            {
                'Name': 'InstanceId',
                'Value': INSTANCE_ID
            },
        ],
        Unit='Percent'
    )
    print(f"Created CloudWatch Alarm: {response}")

# Function to scale the EC2 instance up or down based on the CloudWatch alarm
def scale_instance():
    # Example: Check CloudWatch alarm state and take action
    alarm_state = cloudwatch_client.describe_alarms(
        AlarmNames=[ALARM_NAME]
    )

    alarm = alarm_state['MetricAlarms'][0]
    if alarm['StateValue'] == 'ALARM':
        print("High CPU usage detected. Scaling up...")
        # Scale up the Auto Scaling Group
        response = autoscaling_client.set_desired_capacity(
            AutoScalingGroupName=AUTO_SCALING_GROUP_NAME,
            DesiredCapacity=2  # Increase desired capacity by 1, you can modify the value
        )
        print(f"Auto Scaling group updated: {response}")
    else:
        print("CPU usage is under control. No scaling action required.")

# Function to delete the CloudWatch alarm (optional cleanup)
def delete_cpu_alarm():
    response = cloudwatch_client.delete_alarms(
        AlarmNames=[ALARM_NAME]
    )
    print(f"Deleted CloudWatch Alarm: {response}")

if __name__ == "__main__":
    create_cpu_alarm()  # Optionally, create the alarm if not already created
    scale_instance()  # Check the alarm state and perform scaling