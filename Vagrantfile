# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  #config.vm.box = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"
  config.vm.box = "bgalura/foreman-1.5"

  $foremanscript = <<SCRIPT
echo I am provisioning foreman...

service foreman restart
chkconfig foreman on

yum -y install nc --enablerepo=epel
while ! nc -vz localhost 3000; do sleep 10; done # Wait for foreman to start

# create foreman group base
curl -s -X POST -H "Content-Type:application/json" -H "Accept:application/json" -k -u admin:changeme http://192.168.56.4:3000/api/hostgroups -d '{
  "hostgroup": {
    "name": "base"
  }
}'
# create foreman domain cs.test.internal 
curl -s -X POST -H "Content-Type:application/json" -H "Accept:application/json" -k -u admin:changeme http://192.168.56.4:3000/api/domains -d '{
  "domain": {
    "name": "cs.test.internal"
  }
}'
# create foreman env  production
curl -s -X POST -H "Content-Type:application/json" -H "Accept:application/json" -k -u admin:changeme http://192.168.56.4:3000/api/environments -d '{
  "environment": {
    "name": "production"
  }
}'
# create foreman OS  
curl -s -X POST -H "Content-Type:application/json" -H "Accept:application/json" -k -u admin:changeme http://192.168.56.4:3000/api/operatingsystems -d '{
  "operatingsystem": {
    "name": "CentOS",
    "major": "5",
    "minor": "3"
  }
}'
  config.vm.define "app" do |foremanmysql| 
    foremanmysql.vm.network "forwarded_port", guest: 3000, host: 3000 
    foremanmysql.vm.provision :shell, inline: $foremanscript 
    foremanmysql.vm.box = "bgalura/foreman1.5"
    foremanmysql.vm.provider "virtualbox" do |v|
      v.memory = 2048 
    end
  end
    
  # config.vm.provision "puppet" do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "site.pp"
  # end

end
