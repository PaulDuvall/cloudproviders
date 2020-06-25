# https://diagrams.mingrammer.com/docs/nodes/aws
from diagrams import Cluster, Diagram
from diagrams.aws.compute import Lambda
from diagrams.aws.storage import S3
from diagrams.aws.network import APIGateway
from diagrams.aws.database import DynamodbTable
from diagrams.aws.security import IdentityAndAccessManagementIam
from diagrams.aws.devtools import Codebuild
from diagrams.aws.devtools import Codecommit
from diagrams.aws.devtools import Codedeploy
from diagrams.aws.devtools import Codepipeline
from diagrams.aws.management import Cloudformation
from diagrams.aws.devtools import CommandLineInterface
from diagrams.aws.general import User
from diagrams.aws.general import General
from diagrams.onprem.client import Client

with Diagram("Gradual Deployments", show=False, direction="LR"):


    cloudformation = Cloudformation("CloudFormation Stack")


    with Cluster("CodePipeline"):
        codepipeline = Codepipeline("Pipeline")
        cfn  = Cloudformation("CloudFormation")
        codepipeline >> cfn
        
    with Cluster("Serverless Application Model"):
        sam = Cloudformation("SAM Template")
        apigateway = APIGateway("API Gateway")
        mylambda = Lambda("Lambda")
        ddb  = DynamodbTable("DynamoDB")   
        codedeploy  = Codedeploy("CodeDeploy")
        sam >> apigateway
        sam >> mylambda
        mylambda >> codedeploy
        sam >> ddb
        
        cfn >> sam
        
        cloudformation >> codepipeline
