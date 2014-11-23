#
# Cookbook Name:: my_lamp
# Recipe:: default
#
# Copyright 2014, Yuusaku Miyazaki <toumin.m7@gmail.com>
#
# MIT license
#

# iptables無効 (ファイアウォール)
# なお、selinux(細かなアクセス制御)ははじめから無効になっているので特に操作する必要はない。
service 'iptables' do
    action [:stop, :disable]
end

# レポジトリを追加 (PHP用)
bash 'add_repo_remi' do
  user 'root'
  code <<-EOC
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
  EOC
  creates '/etc/yum.repos.d/remi.repo'
end

# レポジトリを追加 (MySQL用)
bash 'add_repo_mysql' do
  user 'root'
  code <<-EOC
    rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
  EOC
  creates '/etc/yum.repos.d/mysql-community.repo'
end

# パッケージ (Apache)
package 'httpd' do
  action :install
end

# パッケージ (PHP)
%w{php php-common php-mbstring php-xml php-devel php-process php-cli php-pear php-mysql phpmyadmin}.each do |p|
  package p do
    action :install
    options '--enablerepo=remi --enablerepo=remi-php56'
  end
end

# パッケージ (MySQL)
package 'mysql-community-server' do
  action :install
  options '--enablerepo=mysql56-community'
end

# パッケージ (yaml)
%w{libyaml libyaml-devel}.each do |p|
  package p do
    action :install
  end
end

# パッケージ (Node.js, JSDoc)
%w{nodejs npm}.each do |p|
  package p do
    action :install
  end
end

# パッケージ (Phalcon)
%w{git pcre-devel gcc make}.each do |p|
  package p do
    action :install
  end
end

# SSH公開鍵を作成
username = 'vagrant'
bash 'ssh-keygen' do
  user username
  code <<-EOC
    ssh-keygen -t rsa -q -f /home/#{username}/.ssh/id_rsa -P ""
  EOC
  creates "/home/#{username}/.ssh/id_rsa.pub"
end

# npmでJSDocをインストール
bash 'add_npm_jsdoc' do
  user 'root'
  code <<-EOC
    npm install -g jsdoc
  EOC
  creates '/usr/bin/jsdoc'
end

# PECLでYamlをインストール
bash 'add_pecl_yaml' do
  user 'root'
  code <<-EOC
    pecl install yaml
  EOC
  creates '/usr/lib64/php/modules/yaml.so'
end

# PEARでphpDocumentorをインストール
bash 'add_pear_phpDocumentor' do
  user 'root'
  code <<-EOC
    pear channel-discover pear.phpdoc.org
    pear install phpdoc/phpDocumentor
  EOC
  creates '/usr/bin/phpdoc'
end

# gitでcphalconをインストール
bash 'add_git_cphalcon' do
  user 'root'
  code <<-EOC
    cd /home/vagrant
    git clone git://github.com/phalcon/cphalcon.git
    cd cphalcon/build
    ./install
  EOC
  creates '/usr/lib64/php/modules/phalcon.so'
end

# 設定ファイル (共有フォルダのマウント後にhttpdを起動するため)
cookbook_file '/etc/init/httpd.conf' do
  source 'httpd.conf'
  mode '0644'
end

# 設定ファイル (Welcomeページの表示を阻止)
cookbook_file '/etc/httpd/conf.d/welcome.conf' do
  source 'welcome.conf'
  mode '0644'
end

# 設定ファイル (httpd)
template '/etc/httpd/conf/httpd.conf' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :allow_override => 'All', # for mod_rewrite
    :enable_mmap => 'Off',
    :enable_sendfile => 'Off'
  )
  notifies :reload, 'service[httpd]'
end

# 設定ファイル (php)
template '/etc/php.ini' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :timezone => 'Asia/Tokyo',
    :ext_pdo => 'extension=pdo.so', # for Phalcon
    :ext_yaml => 'extension=yaml.so',
    :ext_phalcon => 'extension=phalcon.so'
  )
  notifies :reload, 'service[httpd]'
end

# 設定ファイル (phpMyAdmin)
template '/etc/httpd/conf.d/phpMyAdmin.conf' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :allow_from => '192.168.33.'
  )
  notifies :reload, 'service[httpd]'
end

# 設定ファイル (phpMyAdmin その2)
template '/etc/phpMyAdmin/config.inc.php' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :auth_type => 'cookie',
    :allow_no_password => 'TRUE'
  )
  notifies :reload, 'service[httpd]'
end

# Apacheの起動
service 'httpd' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

# MySQLの起動
service 'mysqld' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end