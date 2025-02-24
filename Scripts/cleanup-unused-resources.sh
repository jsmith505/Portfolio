#!/bin/bash

# Exit on error
set -e

# AWS CLI profile and region (set if you use a non-default profile or region)
AWS_PROFILE="your-profile"
AWS_REGION="us-east-1"

# Cleanup Unused EC2 Instances
cleanup_ec2_instances() {
  echo "Cleaning up unused EC2 instances..."

  # Get a list of all EC2 instances in 'stopped' state
  stopped_instances=$(aws ec2 describe-instances --profile "$AWS_PROFILE" --region "$AWS_REGION" --query "Reservations[*].Instances[?State.Name=='stopped'].InstanceId" --output text)

  if [ -n "$stopped_instances" ]; then
    echo "Stopping EC2 instances: $stopped_instances"
    aws ec2 terminate-instances --profile "$AWS_PROFILE" --region "$AWS_REGION" --instance-ids $stopped_instances
  else
    echo "No stopped EC2 instances found."
  fi
}

# Cleanup Unused Elastic IPs
cleanup_eip() {
  echo "Cleaning up unused Elastic IPs..."

  # Get list of all EIPs that are not associated with any instance
  unused_eips=$(aws ec2 describe-addresses --profile "$AWS_PROFILE" --region "$AWS_REGION" --query "Addresses[?AssociationId==null].PublicIp" --output text)

  if [ -n "$unused_eips" ]; then
    for eip in $unused_eips; do
      echo "Releasing Elastic IP: $eip"
      aws ec2 release-address --profile "$AWS_PROFILE" --region "$AWS_REGION" --public-ip "$eip"
    done
  else
    echo "No unused Elastic IPs found."
  fi
}

# Cleanup Unused EBS Volumes
cleanup_ebs_volumes() {
  echo "Cleaning up unused EBS volumes..."

  # Get list of all EBS volumes in 'available' state (not attached to any instance)
  unused_volumes=$(aws ec2 describe-volumes --profile "$AWS_PROFILE" --region "$AWS_REGION" --query "Volumes[?State=='available'].VolumeId" --output text)

  if [ -n "$unused_volumes" ]; then
    for volume in $unused_volumes; do
      echo "Deleting unused EBS volume: $volume"
      aws ec2 delete-volume --profile "$AWS_PROFILE" --region "$AWS_REGION" --volume-id "$volume"
    done
  else
    echo "No unused EBS volumes found."
  fi
}

# Cleanup Unused Snapshots
cleanup_snapshots() {
  echo "Cleaning up unused snapshots..."

  # Get list of all snapshots older than 7 days
  old_snapshots=$(aws ec2 describe-snapshots --profile "$AWS_PROFILE" --region "$AWS_REGION" --query "Snapshots[?StartTime<'$(date -d '7 days ago' --utc +%Y-%m-%dT%H:%M:%SZ')'].SnapshotId" --output text)

  if [ -n "$old_snapshots" ]; then
    for snapshot in $old_snapshots; do
      echo "Deleting old snapshot: $snapshot"
      aws ec2 delete-snapshot --profile "$AWS_PROFILE" --region "$AWS_REGION" --snapshot-id "$snapshot"
    done
  else
    echo "No old snapshots found."
  fi
}

# Main function to invoke cleanup tasks
main() {
  cleanup_ec2_instances
  cleanup_eip
  cleanup_ebs_volumes
  cleanup_snapshots

  echo "Cleanup process completed."
}

# Run the cleanup
main