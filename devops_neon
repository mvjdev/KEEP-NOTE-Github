#### Fichier yml:

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
    Default: bpartners
  DatabaseUsername:
    Type: String
  DatabasePassword:
    Type: String

Resources:
  # S3 Bucket for storage
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

  # Lambda function to interact with Neon API
  NeonDatabaseFunction:
    Type: AWS::Lambda::Function
    Properties:
      Handler: index.handler
      Runtime: nodejs18.x  # Change to a supported runtime
      Role: !GetAtt LambdaExecutionRole.Arn
      Code:
        ZipFile: |
          const axios = require('axios');
          exports.handler = async (event) => {
            const { RequestType, ResourceProperties } = event;
            console.log(`Event: ${JSON.stringify(event)}`);  // Log the event for debugging
            if (RequestType === 'Create') {
              try {
                const response = await axios.post(`https://console.neon.tech/api/v2/projects/${ResourceProperties.NeonProjectId}/databases`, {
                  name: ResourceProperties.DatabaseName,
                  owner_name: ResourceProperties.DatabaseUsername,
                  owner_password: ResourceProperties.DatabasePassword
                });
                return {
                  PhysicalResourceId: response.data.id,
                  Data: { DatabaseId: response.data.id }
                };
              } catch (error) {
                console.error(`Error creating Neon database: ${error.message}`);  // Log error
                throw new Error(`Error creating Neon database: ${error.message}`);
              }
            }
          };

  # Custom Resource for Neon database
  NeonDatabase:
    Type: Custom::NeonDatabase
    Properties:
      ServiceToken: !GetAtt NeonDatabaseFunction.Arn
      NeonProjectId: !Ref NeonProjectId
      DatabaseName: !Ref DatabaseName
      DatabaseUsername: !Ref DatabaseUsername
      DatabasePassword: !Ref DatabasePassword

Outputs:
  BucketName:
    Value: !Ref Bucket
  NeonDatabaseId:
    Value: !GetAtt NeonDatabase.DatabaseId

```

### aws configure pour mettre le ACCESS KEY ET SECRET_KEY_ID

```|
aws cloudformation create-stack \                                                                                       1m 44s 15:05:13
    --stack-name stack \
    --template-body file://./neon-stacks/neon-storage-database-stack.yml \
    --parameters ParameterKey=Env,ParameterValue=dev \
                 ParameterKey=DatabaseName,ParameterValue=bp-neon-db \
                 ParameterKey=DatabaseUsername,ParameterValue=ADMIN \
                 ParameterKey=DatabasePassword,ParameterValue=123456lLslkdfkjsklfjskldfjMSDf\?^ds \
                 ParameterKey=NeonProjectId,ParameterValue=steep-firefly-94193208 \
    --capabilities CAPABILITY_NAMED_IAM
```

