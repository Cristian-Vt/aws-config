aws configservice select-aggregate-resource-config --region us-east-1 --expression \
     "SELECT
       accountId,
       resourceName,
       resourceId,
       configuration.userName
     WHERE
       resourceType = 'AWS::IAM::User'
       AND configuration.attachedManagedPolicies.policyName = 'AdministratorAccess'
     ORDER BY
       accountId" \
   --configuration-aggregator-name All-Organization-Accounts \
   --output text | \
 grep 'RESULTS' | \
 cut -c9- | \
 jq -r '. | [.accountId, .resourceName, .resourceId, .configuration.userName] | @csv' > list-admin-iam-users.csv
 sort -u list-admin-iam-users.csv -o list-admin-iam-users.csv