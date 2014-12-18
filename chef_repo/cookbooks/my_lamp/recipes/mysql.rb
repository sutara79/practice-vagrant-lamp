#
# Cookbook Name:: my_lamp
# Recipe:: mysql
#

# レポジトリを追加 (MySQL用)
bash 'add_repo_mysql' do
  user 'root'
  code <<-EOC
    rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
  EOC
  creates '/etc/yum.repos.d/mysql-community.repo'
end

# パッケージ (MySQL)
package 'mysql-community-server' do
  action :install
  options '--enablerepo=mysql56-community'
end