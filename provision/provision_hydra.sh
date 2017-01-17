#!/bin/bash

FITS="1.0.2"
RUBY="2.3.3"
RAILS="5.0.0.1"
FITSDIR="/home/vagrant"
APPDIR="/home/vagrant"

sudo yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel 
sudo yum install -y java-1.8.0-openjdk.x86_64 wget unzip

# Install rbenv https://github.com/rbenv/rbenv
# See https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-centos-7 
cd
if [ ! -d /home/vagrant/.rbenv ]
then
  echo 'Installing .rbenv'
  git clone git://github.com/sstephenson/rbenv.git .rbenv  
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile  
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build  
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile  
  # reload bash_profile
  source ~/.bash_profile 
else
  echo '.rbenv is installed, moving on ...'
fi

echo 'Installing ruby '$RUBY
rbenv install $RUBY 
rbenv global $RUBY

echo 'Installing LibreOffice, ImageMagick and Redis'
# LibreOffice
sudo yum install –y libreoffice 
# Install ImageMagick
sudo yum install –y ImageMagick
# Install Redis - enable EPEL 
# See https://support.rackspace.com/how-to/install-epel-and-additional-repositories-on-centos-and-red-hat/
yes | sudo yum install -y epel-release
# If the above doesn't work
if yum repolist | grep epel; then
  echo 'EPEL is enabled'
else
  echo 'Adding the EPEL Repo'
  wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm 
  sudo rpm -Uvh epel-release-latest-7*.rpm
fi
# Install Redis
yes | sudo yum install -y redis
# Start Redis
# For production, ensure starts at startup
# See http://sharadchhetri.com/2014/10/04/install-redis-server-centos-7-rhel-7/
echo 'Starting Redis'
sudo systemctl start redis.service 
# Install Fits
# See https://github.com/projecthydra-labs/hyrax#characterization
cd 
if [ ! -d $FITSDIR/fits-$FITS ]
then  
  echo 'Downloading Fits '$FITS
  wget http://projects.iq.harvard.edu/files/fits/files/fits-$FITS.zip 
  unzip fits-$FITS.zip 
  rm fits-$FITS.zip 
  chmod a+x fits-$FITS/fits.sh
else
  echo 'Fits is already here, moving on ... '
fi
# Install Rails
echo 'Installing rails '$RAILS
gem install rails -v $RAILS 
# Clone and run hyrax_ulcc
cd
mkdir tmp 
if [ ! -d $APPDIR/hyrax_ulcc ]
then
  echo 'Cloning hyrax_ulcc'
  git clone https://github.com/ULCC/hyrax_ulcc.git 
  cd hyrax_ulcc
  cp /vagrant/install_files/env_rename_me .env
else
  echo 'hyrax_ulcc is already cloned, moving on ... '
fi
cd $APPDIR/hyrax_ulcc
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
echo '2. cd ~/hyrax_ulcc'
echo '3. rake hydra:server'
echo '4. change the DEV_DIR setting in .env if needs be'
echo '5. change config.fits_path in config/initializers/hyrax.rb'
