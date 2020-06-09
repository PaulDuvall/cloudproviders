#!/bin/bash
# sudo chmod +x *.sh
# ./cloudproviders-serverless-app.sh

sudo rm -rf tmp-gitrepo
mkdir tmp-gitrepo
cd tmp-gitrepo
git clone https://github.com/PaulDuvall/cloudproviders.git

aws s3api list-buckets --query 'Buckets[?starts_with(Name, `pmd-serverless-`) == `true`].[Name]' --output text | xargs -I {} aws s3 rb s3://{} --force

sleep 20

aws cloudformation delete-stack --stack-name pmd-serverless-app-us-east-1

aws cloudformation wait stack-delete-complete --stack-name pmd-serverless-app-us-east-1

aws cloudformation delete-stack --stack-name pmd-serverless-app

aws cloudformation wait stack-delete-complete --stack-name pmd-serverless-app

cd cloudproviders/webapp

aws s3 mb s3://pmd-serverless-app-$(aws sts get-caller-identity --output text --query 'Account')

aws s3 cp collection.json \
s3://pmd-serverless-app-$(aws sts get-caller-identity --output text --query 'Account')/postman-env-files/collection.json

aws s3 cp postman_environment.json \
s3://pmd-serverless-app-$(aws sts get-caller-identity --output text --query 'Account')/postman-env-files/postman_environment.json

zip -r pmd-serverless-app.zip .
mkdir zipfiles
cp pipeline.yml zipfiles
mv pmd-serverless-app.zip zipfiles
cd zipfiles

aws s3 sync . s3://pmd-serverless-app-$(aws sts get-caller-identity --output text --query 'Account')

aws cloudformation create-stack --stack-name pmd-serverless-app --capabilities CAPABILITY_NAMED_IAM --disable-rollback --template-body file://pipeline.yml --parameters ParameterKey=CodeCommitS3Bucket,ParameterValue=pmd-serverless-app-$(aws sts get-caller-identity --output text --query 'Account') ParameterKey=CodeCommitS3Key,ParameterValue=pmd-serverless-app.zip