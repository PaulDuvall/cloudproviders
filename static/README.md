## Create an S3 Bucket

```aws s3 mb s3://BUCKETNAME``

1. Choose the *Properties* pane and configure **Static website hosting for the S3 bucket**.
1. Choose **Use this bucket to host a website**.
1. Enter `index.html` for **Index document**.
1. Click the *Save** button.

## Launch CloudFormation Stack

Run this command to launch the CloudFormation Stack that provisions all the AWS resources in this solution. 
 
```aws cloudformation create-stack --stack-name cloudproviders-pipeline --capabilities CAPABILITY_NAMED_IAM --disable-rollback --template-body file:///home/ec2-user/environment/cloudproviders/static/pipeline.yml --parameters ParameterKey=CreateS3Bucket,ParameterValue=donotcreate```
