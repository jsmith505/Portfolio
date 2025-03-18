import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):
    bucket_name = event['detail']['requestParameters']['bucketName']
    response = s3.put_bucket_acl(
        Bucket=bucket_name,
        ACL='private'
    )
    return response