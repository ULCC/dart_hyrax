#!/bin/bash

# install rbenv and ruby 2.3.3
sudo yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel 
cd
if [ ! -d /home/vagrant/.rbenv ]; then
  git clone git://github.com/sstephenson/rbenv.git .rbenv  
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile  
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile 
  exec $SHELL
fi

if [ ! -d /home/vagrant/.rbenv/plugins/ruby-build ]; then  
  git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build  
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile  
  exec $SHELL 
  source ~/.bash_profile 
fi

rbenv install 2.3.3 
rbenv global 2.3.3

# LibreOffice
sudo yum –y install libreoffice 
# Install ImageMagick
sudo yum –y install ImageMagick
# Install Redis 
sudo yum install –y wget
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm 
sudo rpm -Uvh epel-release-latest-7*.rpm 
sudo yum –y install redis
# Start Redis
echo 'Starting Redis'
sudo systemctl start redis.service 
# Install Fits
cd 
if [ ! -d /home/vagrant/fits-1.0.2 ]; then  
  wget http://projects.iq.harvard.edu/files/fits/files/fits-1.0.2.zip 
  unzip fits-1.0.2.zip 
  rm unzip fits-1.0.2.zip 
  chmod a+x fits-1.0.2/fits.sh
fi
# Install Rails
gem install rails -v 5.0.0.1 
# Clone and run hyrax_ulcc
cd 
if [ ! -d /home/vagrant/hyrax_ulcc ]; then
  git clone https://github.com/ULCC/hyrax_ulcc.git 
  cd hyrax_ulcc
  cp /vagrant/install_files/.env .env
fi

cd /home/vagrant/hyrax_ulcc
bundle install 
rake db:migrate 
# Update the rake task so that we can bind to 0.0.0.0 (so we can use see the app running on the host machine)
cd | bundle show hydra-core
cd lib/tasks
sudo rm hydra.rake
wget https://raw.githubusercontent.com/tdonohue/hydra-head/38b75222e2e6885c63a8847e9ce04635f35fa30e/hydra-core/lib/tasks/hydra.rake

echo 'Provisioning is complete, now follow these steps:'
echo '1. vagrant ssh'
echo '2. cd /home/vagrant/hyrax_ulcc'
echo '3. rake hydra:server'
