#!/bin/bash
# sudo chmod +x *.sh
# ./terminate-gradual.sh

sudo rm -rf tmp-gitrepo

aws s3api list-buckets --query 'Buckets[?starts_with(Name, `pmd-safe-`) == `true`].[Name]' --output text | xargs -I {} aws s3 rb s3://{} --force

sleep 20

aws cloudformation delete-stack --stack-name pmd-safe-app-us-east-1

aws cloudformation wait stack-delete-complete --stack-name pmd-safe-app-us-east-1

aws cloudformation delete-stack --stack-name pmd-safe-app

aws cloudformation wait stack-delete-complete --stack-name pmd-safe-app
