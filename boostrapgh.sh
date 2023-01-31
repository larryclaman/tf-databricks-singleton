#!/bin/bash
# Boostrap


ADAPPNAME="tfghdbdemo"

ADAPPJSON=$(az ad app create --display-name $ADAPPNAME)
appId=$(echo $ADAPPJSON|jq -r .appId)
appObjId=$(echo $ADAPPJSON|jq -r .id)
SPJSON=$(az ad sp create --id $appId)
spId=$(echo $SPJSON|jq -r .id)

az role assignment create --role contributor --subscription $subscriptionId \
    --assignee-object-id  $spId \
    --assignee-principal-type ServicePrincipal \
    --scope /subscriptions/$subscriptionId

CREDNAME="tfghdbdemocred"
ORG="larryclaman"
REPO="tf-databricks-singleton"
#
az rest --method POST --uri "https://graph.microsoft.com/beta/applications/$appObjId/federatedIdentityCredentials" \
    --body '{"name":"$CREDNAME","issuer":"https://token.actions.githubusercontent.com","subject":"repo:$ORG/$REPO:environment:Production","description":"Testing","audiences":["api://AzureADTokenExchange"]}'
