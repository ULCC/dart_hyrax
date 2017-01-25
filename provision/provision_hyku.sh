#!/bin/bash

# Install postgress
# See https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-centos-7
# also change 'peer' to md5
# restart postgres
# create user
# create database

# we'll need make for the bundle install - this takes a while, might be better doing yum install make
# yes | sudo yum groupinstall "Development Tools"
yes | sudo yum install -y make

yes | sudo yum install -y postgresql-server postgresql-contrib postgresql-devel
sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Clone and run hyku
cd
if [ ! -d hyku ]
then
  echo 'Cloning hyku'
  git clone https://github.com/projecthydra-labs/hyku
  cd hyku
else
  echo 'hyku is already cloned, moving on ... '
fi
cd
cd hyku
echo 'Running bundler and db:migrate'
bundle install 
rake db:migrate 
# Update the rake task so that we can bind to 0.0.0.0 (needed in vagrant to see the app running on localhost on the host machine)
# NB: fiddling with installed gems is a BAD thing to do but it's only needed for local vagrant boxes and development
echo 'Replacing the hydra-rake task so that we can bind to 0.0.0.0'
cd $(bundle show hydra-core)
cd lib/tasks
sudo rm hydra.rake
wget https://raw.githubusercontent.com/tdonohue/hydra-head/38b75222e2e6885c63a8847e9ce04635f35fa30e/hydra-core/lib/tasks/hydra.rake
echo 'Provisioning is complete, now follow these steps:'
echo '1. vagrant ssh'
echo '2. cd ~/hyku'
echo '3. rake hydra:server'
