#!/bin/bash
# sudo chmod +x *.sh
# ./safe-terminate.sh

sudo rm -rf tmp-gitrepo

aws s3api list-buckets --query 'Buckets[?starts_with(Name, `pmd-safe-`) == `true`].[Name]' --output text | xargs -I {} aws s3 rb s3://{} --force

sleep 20

aws cloudformation delete-stack --stack-name pmd-safe2-app-us-east-1

sleep 50

aws cloudformation delete-stack --stack-name pmd-safe2-app

sleep 25