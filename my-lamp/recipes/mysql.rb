#
# Cookbook Name:: my_lamp
# Recipe:: mysql
#

# レポジトリを追加 (MySQL用)
# 参照: http://dev.mysql.com/downloads/repo/yum/
bash 'add-repo-mysql' do
  user 'root'
  code <<-EOC
    rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
  EOC
  creates '/etc/yum.repos.d/mysql-community.repo'
end

# パッケージ (MySQL)
# 参照: http://dev.mysql.com/doc/mysql-yum-repo-quick-guide/en/
package 'mysql-community-server' do
  action :upgrade
  options '--enablerepo=mysql56-community'
end

# 起動
service 'mysqld' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

# (自分専用)データベースを登録
bash 'add-database' do
  user 'root'
  code <<-EOC
    mysqladmin -uroot create test
    mysql -uroot test < /var/www/html/php/ajax-combobox/sample/sample_mysql.sql
  EOC
  not_if 'mysqlshow | grep test'
  only_if {node.git.user.email == 'toumin.m7@gmail.com'}
end