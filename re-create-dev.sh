#!/bin/bash
export ANSIBLE_CONFIG_FILE=vars-dev.yml
ansible-playbook k3s.yml --syntax-check \
&& vagrant destroy -f \
&& time vagrant up --provision
