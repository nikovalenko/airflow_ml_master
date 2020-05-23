#!/bin/bash

function install_anaconda() {
    wget --quiet https://repo.continuum.io/archive/Anaconda3-2019.03-Linux-x86_64.sh -O Anaconda-latest-Linux-x86_64.sh

    bash Anaconda-latest-Linux-x86_64.sh

    rm -f Anaconda-latest-Linux-x86_64.sh
}

function install_with_forge_conda() {
    for PACKAGE in $*; do
        conda install -qy -c conda-forge $PACKAGE
    done
}

function gen_creds() {
    read -p 'ACCESS_KEY:' ACCESS_KEY
    read -p 'SECRET_KEY:' SECRET_KEY
    read -p 'REGION:' REGION

    echo "provider \"aws\" { access_key = \"$ACCESS_KEY\" secret_key = \"$SECRET_KEY\" region = \"$REGION\" }" > creds.tf

    aws configure --profile master_dp_user set region $REGION
    aws configure --profile master_dp_user set aws_access_key_id $ACCESS_KEY
    aws configure --profile master_dp_user set aws_secret_access_key $SECRET_KEY
}

function create_conda_env() {
    source $HOME/anaconda3/etc/profile.d/conda.sh

    conda create --name awscli
    conda activate awscli

    install_with_forge_conda \
        terraform=0.11.13 \
        awscli \
        jq

}

install_anaconda
create_conda_env
gen_creds