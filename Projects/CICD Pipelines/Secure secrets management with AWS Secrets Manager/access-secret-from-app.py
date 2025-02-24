import boto3
from botocore.exceptions import NoCredentialsError

# Initialize a session using AWS Secrets Manager
secrets_client = boto3.client('secretsmanager')

# Function to retrieve the secret value
def get_secret(secret_name):
    try:
        response = secrets_client.get_secret_value(SecretId=secret_name)
        secret = response['SecretString']
        return secret
    except NoCredentialsError:
        print("Credentials not found!")
        return None

# Get the secret
secret_name = 'MyDatabaseCredentials'
secret = get_secret(secret_name)
print(f"Secret: {secret}")
