# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'centos65-x86_64-20140116'
  config.vm.network 'private_network', ip: '192.168.33.10'
  config.vm.network 'public_network', ip: '192.168.1.100'
  config.vm.synced_folder '../../server', '/var/www/html'
  #config.vm.synced_folder '//192.168.1.10/Users/Yuusaku/Pictures', '/home/vagrant/photo', type: 'smb', smb_username: 'Yuusaku', smb_password: '2113'
  config.vm.provision :chef_zero do |chef|
    chef.cookbooks_path = './'
    chef.run_list = 'recipe[my-lamp::default]'
    chef.json = {
      :php => {
        :timezone => 'Asia/Tokyo',
        :allow_from => '192.168.'
      }
    }
  end
end