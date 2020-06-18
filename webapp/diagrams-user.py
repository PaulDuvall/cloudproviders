# https://diagrams.mingrammer.com/docs/nodes/aws
from diagrams import Cluster, Diagram
from diagrams.aws.compute import Lambda
from diagrams.aws.general import User
from diagrams.aws.network import APIGateway
from diagrams.aws.database import DynamodbTable

from diagrams.aws.devtools import CommandLineInterface

with Diagram("Serverless Web App Workflow", show=False, direction="LR"):

    user = User("User")
    api = APIGateway("API Gateway")
    mylambda = Lambda("Lambda")
    ddb = DynamodbTable("DynamodbTable")
    
    user >> api >> mylambda >> ddb