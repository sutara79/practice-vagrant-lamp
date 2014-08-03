# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos65-x86_64-20140116"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.omnibus.chef_version = :latest
  config.vm.provision :chef_solo do |chef|
    chef.custom_config_path = "Vagrantfile.chef"
    chef.cookbooks_path = "chef_repo/cookbooks"
    chef.roles_path = "chef_repo/roles"
    chef.data_bags_path = "chef_repo/data_bags"
    chef.run_list = "my_lamp"
  end
end
