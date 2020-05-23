#!/bin/bash
source /home/centos/anaconda2/etc/profile.d/conda.sh
conda activate py36
airflow initdb
