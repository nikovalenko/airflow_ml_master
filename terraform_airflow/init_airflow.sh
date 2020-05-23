#!/bin/bash

source $HOME/anaconda3/etc/profile.d/conda.sh

function init_terraforming() {
    terraform init
    terraform apply -auto-approve
    terraform output -json > output.json
}

function perform_rule_changes() {
    EC2_SEC=$(jq -r '.ec2_sec_group_id.value' output.json)
    CB_SEC=$(jq -r '.cb_sec_group_id.value' output.json)
    aws ec2 authorize-security-group-ingress \
        --group-id $EC2_SEC \
        --protocol tcp \
        --port 22 \
        --source-group $CB_SEC \
        --profile master_dp_user
    aws ec2 revoke-security-group-ingress \
        --group-id $EC2_SEC \
        --protocol tcp \
        --port 22 \
        --cidr 0.0.0.0/0 \
        --profile master_dp_user
}

conda activate awscli
init_terraforming
perform_rule_changes
rm output.json

