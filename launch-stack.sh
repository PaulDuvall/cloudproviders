#!/bin/bash
# sudo chmod +x *.sh
# ./launch-stack.sh

AWS_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')

MYNAME=${1:-iam-branch}
PROJECTNAME=${2:-cloudproviders}
TMPDIR=${3:-.tmp-gitrepo}   
S3BUCKET=${4:-$PROJECTNAME-$MYNAME}
SAMSTACK=${5:-$PROJECTNAME-$MYNAME-$AWS_REGION}
CFNSTACK=${6:-$PROJECTNAME-$MYNAME}
PIPELINEYAML=${7:-pipeline.yml}
OTHER=${8:-cloudproviders-pmd}

sudo rm -rf $TMPDIR
mkdir $TMPDIR
cd $TMPDIR
git clone -b iam https://github.com/PaulDuvall/cloudproviders.git cp-iam


aws s3api list-buckets --query 'Buckets[?starts_with(Name, `'$OTHER'`) == `true`].[Name]' --output text | xargs -I {} aws s3 rb s3://{} --force

aws s3api list-buckets --query 'Buckets[?starts_with(Name, `'$S3BUCKET'`) == `true`].[Name]' --output text | xargs -I {} aws s3 rb s3://{} --force


sleep 20

aws cloudformation delete-stack --stack-name $SAMSTACK

aws cloudformation wait stack-delete-complete --stack-name $SAMSTACK

aws cloudformation delete-stack --stack-name $CFNSTACK

aws cloudformation wait stack-delete-complete --stack-name $CFNSTACK


cd cp-iam/webapp

aws s3 mb s3://$S3BUCKET-$(aws sts get-caller-identity --output text --query 'Account')

aws s3 cp collection.json \
s3://$S3BUCKET-$(aws sts get-caller-identity --output text --query 'Account')/postman-env-files/collection.json

aws s3 cp postman_environment.json \
s3://$S3BUCKET-$(aws sts get-caller-identity --output text --query 'Account')/postman-env-files/postman_environment.json

zip -r $S3BUCKET.zip .
mkdir zipfiles
cp $PIPELINEYAML zipfiles
mv $S3BUCKET.zip zipfiles
cd zipfiles

aws s3 sync . s3://$S3BUCKET-$(aws sts get-caller-identity --output text --query 'Account')

aws cloudformation create-stack --stack-name $CFNSTACK --capabilities CAPABILITY_NAMED_IAM --disable-rollback --template-body file://$PIPELINEYAML --parameters ParameterKey=CodeCommitS3Bucket,ParameterValue=$S3BUCKET-$(aws sts get-caller-identity --output text --query 'Account') ParameterKey=CodeCommitS3Key,ParameterValue=$S3BUCKET.zip