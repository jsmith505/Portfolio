# DynamoDB 

## Overview
Amazon DynamoDB is a fully managed NoSQL database service that provides fast and predictable performance with seamless scalability.

## Key Features
- **Fully Managed**: No need to worry about hardware provisioning, setup, or maintenance.
- **Serverless**: Automatically scales based on workload.
- **Single-Digit Millisecond Latency**: Ideal for high-performance applications.
- **Multi-Region Replication**: With Global Tables, data is replicated across multiple AWS regions.
- **Built-in Security**: Encryption at rest and in transit.
- **Event-Driven Architecture**: Integrated with AWS Lambda for real-time processing.

## Core Concepts
### Tables
- Contains multiple **items** (similar to rows in relational databases).
- Each item has one **primary key** (Partition Key or Partition + Sort Key).

### Primary Keys
- **Partition Key (Hash Key)**: Determines the partition where data is stored.
- **Composite Key (Partition + Sort Key)**: Enables range queries and better organization.

### Secondary Indexes
- **Global Secondary Index (GSI)**: Different partition and sort key than the base table.
- **Local Secondary Index (LSI)**: Same partition key as the base table but different sort key.

### Read & Write Capacity Modes
- **Provisioned Mode**: Set read/write capacity (RCU/WCU) manually.
- **On-Demand Mode**: Scales automatically with traffic (pay-per-request).

### Data Consistency
- **Eventually Consistent Reads** (default): Faster but may return stale data.
- **Strongly Consistent Reads**: Guarantees the latest data but may have higher latency.

### Pricing Considerations
- **Storage Costs**: Charged per GB stored.
- **Read/Write Costs**: Based on RCU/WCU in provisioned mode or per request in on-demand mode.
- **Data Transfer Costs**: Charged for data moving across regions.

## Use Cases
- **Session Management**: Store user sessions for web apps.
- **Gaming Leaderboards**: Fast and scalable ranking systems.
- **IoT Applications**: High-ingestion rate for sensor data.
- **E-Commerce**: Product catalogs and shopping carts.
- **Event Logging**: Store logs for real-time processing with AWS Lambda.

## Best Practices
- Choose **On-Demand Mode** for unpredictable workloads.
- Use **GSIs** for flexible querying patterns.
- **Avoid hot partitions** by distributing data evenly across partitions.
- Use **DynamoDB Streams** for real-time event processing.
- Enable **Auto Scaling** to adjust capacity dynamically.

## Related AWS Services
- **DynamoDB Streams**: Triggers Lambda functions for event-driven workflows.
- **Amazon S3**: Archive cold data for cost optimization.
- **AWS Glue**: ETL for analytics on DynamoDB data.
- **Amazon Kinesis**: Complementary for real-time data streaming.
- **AWS IAM**: Fine-grained access control to DynamoDB tables.

