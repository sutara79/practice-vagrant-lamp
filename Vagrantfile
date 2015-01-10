# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'centos65-x86_64-20140116'
  config.vm.network 'private_network', ip: '192.168.33.10'

  # 共有フォルダを変更する
  config.vm.synced_folder '../../server', '/var/www/html'

  # vagrant-omnibusを導入する必要のない場合(Macなど)はコメントアウトする
  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    #TODO: 削除
    # chef.custom_config_path = 'Vagrantfile.chef'

    chef.cookbooks_path = '../'
    chef.run_list = "recipe[#{File.basename(Dir::pwd)}::default]"
    # chef.cookbooks_path = 'chef_repo/cookbooks'
    # chef.run_list = ['my_lamp']

    chef.json = {
      :username => 'vagrant',
      :git => {
        :version => 'git-2.2.1',
        :user => {
          :email => 'toumin.m7@gmail.com',
          :name => 'Yuusaku Miyazaki'
        }
      },
      :php => {
        :timezone => 'Asia/Tokyo',
        :allow_from => '192.168.33.'
      },
      :ruby => {
        :version => 'ruby-2.1.5'
      }
    }
  end
end