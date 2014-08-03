#
# Cookbook Name:: my_lamp
# Recipe:: default
#
# Copyright 2014, Yuusaku Miyazaki <toumin.m7@gmail.com>
#
# MIT license
#

# LAMP
# - CentOS 6.5
# - Apache 2.2
# - MySQL 5.6
# - PHP 5.6 

# 変数
conf_httpd = '/etc/httpd/conf/httpd.conf'
conf_phpMyAdmin = '/etc/httpd/conf.d/phpMyAdmin.conf'
conf_phpMyAdmin2 = '/etc/phpMyAdmin/config.inc.php'

# Attribute
node.default['httpd']['docroot'] = '/vagrant/public_html'
node.default['phpmyadmin']['auth_type'] = 'cookie'
node.default['phpmyadmin']['AllowNoPassword'] = 'TRUE'
node.default['phpmyadmin']['Allow_from'] = '192.168.33.'

# iptables無効
service 'iptables' do
    action [:stop, :disable]
end

# 共有フォルダ内にApacheのドキュメントルートを置くため、ディレクトリを作成する
directory node['httpd']['docroot'] do
  owner 'root'
  group 'root'
  action :create
end

# レポジトリを追加 (PHP用)
bash 'add_repo_remi' do
  user 'root'
  code <<-EOC
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
  EOC
  creates 'remi.repo'
end

# レポジトリを追加 (MySQL用)
bash 'add_repo_mysql' do
  user 'root'
  code <<-EOC
    rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
  EOC
  creates 'mysql-community.repo'
end

# Apache, PHPのインストール
%w{httpd php php-common php-mbstring php-xml php-devel php-process php-cli php-pear php-mysql mysql-community-server phpmyadmin}.each do |p|
  package p do
    #action :upgrade
    action :install
    options '--enablerepo=remi --enablerepo=remi-php56'
  end
end

# 設定ファイルを読み込む
# 共有フォルダのマウント後にhttpdを起動するための設定
cookbook_file '/etc/init/httpd.conf' do
  source 'httpd.conf'
  mode '0644'
end

# 設定ファイルをテンプレートから作成
[conf_httpd, conf_phpMyAdmin, conf_phpMyAdmin2].each do |t|
  template t do
    owner 'root'
    group 'root'
    mode '0644'
  end
end

# Apacheの起動
service 'httpd' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
  subscribes :restart, "template[#{conf_httpd}]"
  subscribes :restart, "template[#{conf_phpMyAdmin}]"
  subscribes :restart, "template[#{conf_phpMyAdmin2}]"
end

# MySQLの起動
service 'mysqld' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end