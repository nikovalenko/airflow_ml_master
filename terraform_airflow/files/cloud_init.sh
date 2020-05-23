#!/bin/bash

set -x

function install_anaconda() {
    wget --quiet https://repo.continuum.io/archive/Anaconda2-5.1.0-Linux-x86_64.sh -O Anaconda-latest-Linux-x86_64.sh

    bash Anaconda-latest-Linux-x86_64.sh -f -b -p /home/centos/anaconda2 > /dev/null

    rm -f Anaconda-latest-Linux-x86_64.sh
}

function install_terraform() {
    wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip

    unzip ./terraform_0.11.13_linux_amd64.zip -d /usr/local/bin/

    rm -f terraform_0.11.13_linux_amd64.zip
}

function install_with_forge_conda() {
    for PACKAGE in $*; do
        conda install -y conda-forge $PACKAGE
    done
}

function install_with_conda() {
    for PACKAGE in $*; do
        conda install -qy $PACKAGE
    done
}

function install_with_pip() {
    for PACKAGE in $*; do
        pip install -q $PACKAGE
    done
}

function install_dependencies() {
    yum install -y gcc
    yum install -y bzip2
    yum install -y wget
    yum install -y unzip
    yum install -y awscli
}

function install_python_and_python_packages() {
    echo ". /home/centos/anaconda2/etc/profile.d/conda.sh" >> /home/centos/.bashrc

    source /home/centos/anaconda2/etc/profile.d/conda.sh

    conda update -yn base conda
    conda create -q -yn py36 python=3.6
    conda activate py36

    pip install -q --upgrade pip

    install_with_conda \
        numpy \
        scipy \
        scikit-learn
#        pandas


    pip install -qU setuptools --ignore-installed
    pip install 'apache-airflow[s3, postgres]'

    install_with_pip \
        psycopg2-binary \
        cryptography \
        boto3 \
        botocore \
        cachetools \
        certifi \
        chardet \
        docutils \
        httplib2 \
        idna \
        jmespath \
        oauth2client \
        pyasn1 \
        pyasn1-modules \
        python-dateutil \
        requests \
        rsa \
        s3transfer \
        six \
        uritemplate \
        urllib3 \
        s3fs \
        sagemaker==v1.39.2 \
        six=1.11.0 \
        markupsafe \
        git \
        pandas==0.25.3


    chown -R centos: /home/centos/anaconda2
}

function start_airflow() {
    cd ~

    mkdir -p /home/centos/airflow
    mkdir -p /home/centos/airflow/dags
    mkdir -p /home/centos/airflow/dags/states

    mv /var/tmp/airflow.cfg /home/centos/airflow/

    export AIRFLOW_HOME=/home/centos/airflow

    chown -R centos:centos /home/centos/airflow

    conda activate py36
    airflow initdb

    mkdir -p /var/log/airflow

    nohup airflow webserver > /var/log/airflow/webserver.log &
    nohup airflow scheduler > /var/log/airflow/scheduler.log &

    python /var/tmp/airflow_conn.py >> out_con.txt
}

START_TIME=$(date +%s)

service sshd start

install_dependencies
install_terraform
install_anaconda
install_python_and_python_packages
start_airflow

END_TIME=$(date +%s)
ELAPSED=$(($END_TIME - $START_TIME))

echo "Deployment complete. Time elapsed was [$ELAPSED] seconds"
