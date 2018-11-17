#!/usr/bin/env bash

# Sets up okd simple all-in-one localhost Installation
# This script has only been tested on centos 7.5

# Sources
# github https://github.com/openshift/openshift-ansible

# Fixes
# https://github.com/openshift/openshift-ansible/issues/7794

# Run the below manaully
# Setting Repos and Updating OS
sudo yum -y update
sudo yum -y install wget git screen
sudo wget https://storage.googleapis.com/origin-ci-test/releases/openshift/origin/master/origin.repo -O /etc/yum.repos.d/origin.repo
sudo yum -y install epel-release
sudo yum-config-manager --enable epel
sudo yum-config-manager --enable origin-repo
sudo yum -y update

# Installing System Packages
sudo yum install -y NetworkManager
sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager

# Installing Docker
sudo yum install -y docker net-tools
sudo systemctl start docker
sudo systemctl enable docker

# Installing Ansible and Openshift-Ansible Dependencies
sudo yum -y install pyOpenSSL python-lxml python-jinja2
sudo yum -y install http://cbs.centos.org/kojifiles/packages/ansible/2.6.5/1.el7/noarch/ansible-2.6.5-1.el7.noarch.rpm

# Setting Public IP and Hostname
#sudo echo 'okdsrv' | sudo tee --append /etc/hostname
#sudo echo '35.177.53.33   okdsrv' | sudo tee --append /etc/hosts
sudo hostnamectl set-hostname okdsrv

# Reboot the server and run the below manually
# Cloning Openshift-Ansible Repo and Installing a Simple all-in-one okd cluster
screen
git clone https://github.com/openshift/openshift-ansible
cd openshift-ansible
sudo ansible-playbook -i inventory/hosts.localhost playbooks/prerequisites.yml
sudo ansible-playbook -i inventory/hosts.localhost playbooks/deploy_cluster.yml
