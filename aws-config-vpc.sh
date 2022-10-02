#!/bin/bash
aws configservice select-aggregate-resource-config --region us-east-1 --expression \
"SELECT
  accountId,
  arn,
  availabilityZone,
  awsRegion,
  resourceName,
  configuration,
  relationships
WHERE
  resourceType = 'AWS::EC2::VPC'
  AND relationships.resourceType IN (
    'AWS::EC2::Instance',
    'AWS::EC2::InternetGateway',
    'AWS::EC2::NetworkACL',
    'AWS::EC2::RouteTable',
    'AWS::EC2::Subnet',
    'AWS::EC2::SecurityGroup',
    'AWS::EC2::NetworkInterface'
  )" \
   --configuration-aggregator-name All-Organization-Accounts \
   --output text | \
grep 'RESULTS' | \
cut -c9-  | \
jq -r '[{accountId} + {arn} + {availabilityZone} + {awsRegion} + {resourceName} + (.configuration | 
{instanceTenancy} + {isDefault} + {dhcpOptionsId} + {cidrBlock} + {vpcId} + (.cidrBlockAssociationSet[]| 
{cidrBlock} + (.cidrBlockState |
{state}) + {associationId} + (.state |
{value} ) + {ownerId} ) ) + (.relationships[] | 
{resourceId} + {relationshipName} + {resourceType})]| @json' > vpc.json
cat vpc.json | jq -r '(map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv' > vpc.csv

