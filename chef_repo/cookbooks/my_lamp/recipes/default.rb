#
# Cookbook Name:: my_lamp
# Recipe:: default
#
# Copyright 2014, Yuusaku Miyazaki <toumin.m7@gmail.com>
#
# MIT license
#

include_recipe "my_lamp::basic"
include_recipe "my_lamp::git"
include_recipe "my_lamp::httpd"
include_recipe "my_lamp::php"
include_recipe "my_lamp::mysql"
include_recipe "my_lamp::nodejs"
include_recipe "my_lamp::ruby"

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