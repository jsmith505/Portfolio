import boto3
import random
import string

def generate_random_password(length=16):
    # Generates a random password for secret rotation
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

def lambda_handler(event, context):
    secret_name = event['SecretId']
    secret_client = boto3.client('secretsmanager')
    
    # Get current secret value
    current_secret = secret_client.get_secret_value(SecretId=secret_name)
    
    # Generate a new password
    new_password = generate_random_password()
    
    # Update the secret with the new password
    secret_client.update_secret(
        SecretId=secret_name,
        SecretString=json.dumps({"username": current_secret["SecretString"]["username"], "password": new_password})
    )
    
    return {
        'statusCode': 200,
        'body': f'Successfully rotated secret {secret_name}'
    }
