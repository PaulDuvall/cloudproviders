# https://diagrams.mingrammer.com/docs/nodes/aws
from diagrams import Cluster, Diagram
from diagrams.aws.compute import Lambda
from diagrams.aws.general import User
from diagrams.aws.network import APIGateway
from diagrams.aws.database import DynamodbTable
from diagrams.onprem.client import Client
from diagrams.aws.devtools import CommandLineInterface

with Diagram("Serverless Web App Workflow", show=False, direction="LR"):

    user = User("User")
    console = Client("Browser")
    api = APIGateway("API Gateway")
    mylambda = Lambda("Lambda")
    ddb = DynamodbTable("DynamodbTable")
    
    user >> console >> api >> mylambda >> ddb