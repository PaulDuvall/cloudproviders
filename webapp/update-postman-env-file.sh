#!/usr/bin/env bash

#This shell script updates Postman environment file with the API Gateway URL created
# via the api gateway deployment

echo "Running update-postman-env-file.sh"

SAM_STACK_NAME=${1:-junk}   

echo "SAM_STACK_NAME is $SAM_STACK_NAME"

# Get the 3rd Output value (GetDataApi) in the CloudFormation stack https://github.com/PaulDuvall/cloudproviders/blob/master/webapp/sam-http.yml
api_gateway_url=`aws cloudformation describe-stacks \
  --stack-name $SAM_STACK_NAME \
  --query "Stacks[0].Outputs[?OutputKey=='GetDataApi'].OutputValue" --output text`

echo "API Gateway URL:" ${api_gateway_url}

jq -e --arg apigwurl "$api_gateway_url" '(.values[] | select(.key=="apigw-root") | .value) = $apigwurl' \
  postman_environment.json > postman_environment.json.tmp \
  && cp postman_environment.json.tmp postman_environment.json \
  && rm postman_environment.json.tmp

echo "Updated postman_environment.json"

cat postman_environment.json