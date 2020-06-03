#!/bin/bash
# sudo chmod +x *.sh
# ./launch-safe.sh

sudo rm -rf tmp-gitrepo
mkdir tmp-gitrepo
cd tmp-gitrepo
git clone https://github.com/PaulDuvall/cloudproviders.git

aws s3api list-buckets --query 'Buckets[?starts_with(Name, `pmd-safe-`) == `true`].[Name]' --output text | xargs -I {} aws s3 rb s3://{} --force

sleep 20

aws cloudformation delete-stack --stack-name pmd-safe-app-us-east-1

sleep 50

aws cloudformation delete-stack --stack-name pmd-safe-app

sleep 25

cd cloudproviders/webapp

aws s3 mb s3://pmd-safe-app-$(aws sts get-caller-identity --output text --query 'Account')
zip -r pmd-safe-app.zip .
mkdir zipfiles
cp pipeline-safe.yml zipfiles
mv pmd-safe-app.zip zipfiles
cd zipfiles

aws s3 sync . s3://pmd-safe-app-$(aws sts get-caller-identity --output text --query 'Account')

aws cloudformation create-stack --stack-name pmd-safe-app --capabilities CAPABILITY_NAMED_IAM --disable-rollback --template-body file://pipeline-safe.yml --parameters ParameterKey=CodeCommitS3Bucket,ParameterValue=pmd-safe-app-$(aws sts get-caller-identity --output text --query 'Account') ParameterKey=CodeCommitS3Key,ParameterValue=pmd-safe-app.zip