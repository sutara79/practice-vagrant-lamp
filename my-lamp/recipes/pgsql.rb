#
# Cookbook Name:: my_lamp
# Recipe:: pgsql
#

# レポジトリを追加 (PostgreSQL)
# 参照: http://yum.postgresql.org/repopackages.php
bash 'add-repo-pgsql' do
  user 'root'
  code <<-EOC
    rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm
  EOC
  creates '/etc/yum.repos.d/pgdg-94-centos.repo'
end

# パッケージ (PostgreSQL)
# 参照: http://www.postgresql.org/download/linux/redhat/
package 'postgresql94-server' do
  action :upgrade
  options '--enablerepo=pgdg94'
end

# 初期化
bash 'init-pgsql' do
  user 'root'
  code <<-EOC
    service postgresql-9.4 initdb
  EOC
  creates '/var/lib/pgsql/9.4/data/postgresql.conf'
end

# 起動
service 'postgresql-9.4' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

# インポート
bash 'import-pgsql' do
  user 'postgres'
  code <<-EOC
    createdb test
    psql test < /var/www/html/heroku/sutara-php/outfile.sql
  EOC
  #TODO: 既にインポート済みでも実行されてしまう。
  not_if 'psql -c "\l" | grep test'
  only_if {node.git.user.email == 'toumin.m7@gmail.com'}
end