#!/bin/bash

source $HOME/anaconda3/etc/profile.d/conda.sh

conda activate awscli
terraform destroy -auto-approve
