#!/bin/bash
yum update -y
yum install -y python3
aws s3 cp s3://us-west-2-aws-training/courses/SPL-TF-200-NWCDVW/v1.0.14.prod-efe208c6/scripts/vpcapp.zip .
unzip vpcapp.zip
cd vpcapp
pip3 install -r requirements.txt
export DATABASE_HOST=${RDSClusterEndPoint}
export DATABASE_USER=admin
export DATABASE_PASSWORD=testingrdscluster
export DATABASE_DB_NAME=Population
cd loaddatabase
python3 database_populate.py
cd ..
python3 application.py