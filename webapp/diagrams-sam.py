# https://diagrams.mingrammer.com/docs/nodes/aws
# https://www.graphviz.org/doc/info/attrs.html
from diagrams import Cluster, Diagram, Edge
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

graph_attr = {
    "fontsize": "45",
    "bgcolor": "transparent",
    "fillcolor": "red"
}

cluster_attr = {
    "bgcolor": "lightgrey"
}

with Diagram("Canary Deployments", show=False, direction="LR", filename="canary-deployments", graph_attr=graph_attr):

    with Cluster("Launch API URL", direction="LR"):
        user = User("User")
        console = Client("Browser")
        user >> console

    with Cluster("Cloud9", direction="LR"):
        builder = User("Builder")
        cli = CommandLineInterface("AWS CLI")
        builder >> cli
        
    with Cluster("CloudFormation", direction="LR"):
        cloudformation = Cloudformation("Stack")
        cli >> cloudformation

    with Cluster("CodePipeline"):
        codepipeline = Codepipeline("Pipeline")
        cfn  = Cloudformation("Deploy")
        codepipeline >> cfn

    with Cluster("Serverless Application Model (SAM) Stack"):
        sam = Cloudformation("SAM Template")
        apigateway = APIGateway("API Gateway")
        mylambda = Lambda("Lambda")
        ddb  = DynamodbTable("DynamoDB")   
        codedeploy  = Codedeploy("CodeDeploy")
        mylambda >> codedeploy
        sam >> apigateway
        sam >> mylambda
        sam >> ddb
        mylambda >> ddb

        cloudformation >> codepipeline
        cfn >> sam
        console >> apigateway

