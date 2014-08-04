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
httpd_root = '/vagrant/public_html'

# iptables無効 (ファイアウォール)
# なお、selinux(細かなアクセス制御)ははじめから無効になっているので特に操作する必要はない。
service 'iptables' do
    action [:stop, :disable]
end

# 共有フォルダ内にApacheのドキュメントルートを置くため、ディレクトリを作成する
directory httpd_root do
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

# 設定ファイル (共有フォルダのマウント後にhttpdを起動するため)
cookbook_file '/etc/init/httpd.conf' do
  source 'httpd.conf'
  mode '0644'
end

# 設定ファイル (httpd)
template '/etc/httpd/conf/httpd.conf' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :root => httpd_root,
    :enable_mmap => 'Off',
    :enable_sendfile => 'Off'
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