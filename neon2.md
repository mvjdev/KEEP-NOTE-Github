```
AWSTemplateFormatVersion: 2010-09-09
Description: Storage stack for BPartners using Neon

Parameters:
  Env:
    Type: String
  NeonProjectId:
    Type: String
  DatabaseName:
    Type: String
    Default: DatabaseName
  DatabaseUsername:
    Type: String
    Default: DatabaseUsername
  DatabasePassword:
    Type: String
    Default: DatabasePassword
  NeonApiToken:
    Type: String
    Description: NeonApiToken

Resources:
  Bucket:
    Type: AWS::S3::Bucket
    DeletionPolicy: Retain
    Properties:
      VersioningConfiguration:
        Status: Enabled
      PublicAccessBlockConfiguration:
        BlockPublicAcls: true
        BlockPublicPolicy: true
        IgnorePublicAcls: true
        RestrictPublicBuckets: true

  # IAM Role for Lambda
  LambdaExecutionRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: lambda.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: NeonAPIAccess
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - logs:CreateLogGroup
                  - logs:CreateLogStream
                  - logs:PutLogEvents
                  - logs:DescribeLogGroups
                  - logs:DescribeLogStreams
                Resource: arn:aws:logs:*:*:*

  NeonDatabaseFunction:
    Type: AWS::Lambda::Function
    Properties:
      Handler: index.handler
      Runtime: python3.11
      Role: !GetAtt LambdaExecutionRole.Arn
      Code:
        ZipFile: |
          import json
          import boto3
          import requests

          def handler(event, context):
              request_type = event['RequestType']
              neon_project_id = event['ResourceProperties']['NeonProjectId']
              database_name = event['ResourceProperties']['DatabaseName']
              database_username = event['ResourceProperties']['DatabaseUsername']
              database_password = event['ResourceProperties']['DatabasePassword']
              api_token = event['ResourceProperties']['NeonApiToken']
          
              print(f'Event: {json.dumps(event)}')  # Log the event for debugging
          
              if request_type == 'Create':
                  try:
                      response = requests.post(
                          f'https://console.neon.tech/api/v2/projects/{neon_project_id}/databases',
                          json={
                              'name': database_name,
                              'owner_name': database_username,
                              'owner_password': database_password
                          },
                          headers={
                              'Authorization': f'Bearer {api_token}'
                          }
                      )
                      response.raise_for_status()
          
                      # Return the response to CloudFormation
                      return {
                          'Status': 'SUCCESS',
                          'PhysicalResourceId': response.json()['id'],
                          'Data': {'DatabaseId': response.json()['id']}
                      }
                  except Exception as e:
                      print(f'Error creating Neon database: {str(e)}')
                      return {
                          'Status': 'FAILED',
                          'Reason': f'Error creating Neon database: {str(e)}',
                          'PhysicalResourceId': event.get('PhysicalResourceId', 'unknown')
                      }

  NeonDatabase:
    Type: Custom::NeonDatabase
    Properties:
      ServiceToken: !GetAtt NeonDatabaseFunction.Arn
      NeonProjectId: !Ref NeonProjectId
      DatabaseName: !Ref DatabaseName
      DatabaseUsername: !Ref DatabaseUsername
      DatabasePassword: !Ref DatabasePassword
      NeonApiToken: !Ref NeonApiToken

Outputs:
  BucketName:
    Value: !Ref Bucket
  NeonDatabaseId:
    Value: !GetAtt NeonDatabase.DatabaseId

```
