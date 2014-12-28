#
# Cookbook Name:: my_lamp
# Recipe:: git
#

# 古いgitを削除
package 'git' do
  action :remove
end

# # レポジトリを追加
# # 参照: https://packages.endpoint.com/
# bash 'add-repo-endpoint' do
#   user 'root'
#   code <<-EOC
#     cd /tmp
#     wget https://packages.endpoint.com/rhel/6/os/x86_64/endpoint-repo-1.6-1.x86_64.rpm 
#     yum localinstall endpoint-repo-1.6-1.x86_64.rpm
#   EOC
#   creates '/etc/yum.reps.d/endpoint.repo'
# end

# # パッケージ Git
# package 'git' do
#   action :install
#   options '--enablerepo=endpoint'
# end

# パッケージ (Gitの依存ライブラリ)
%w{curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker}.each do |p|
  package p do
    action :install
  end
end

# ソースからインストール (Git最新版)
bash 'install-git' do
  user 'root'
  code <<-EOC
    wget https://www.kernel.org/pub/software/scm/git/#{node.git.version}.tar.gz
    tar zxvf #{node.git.version}.tar.gz
    cd #{node.git.version}
    ./configure –-prefix=/usr/local/ --with-curl --with-expat
    make prefix=/usr/local all
    make prefix=/usr/local install
  EOC
  not_if 'which git'
end

# 設定ファイル (.gitconfig)
template "/home/#{node.username}/.gitconfig" do
  owner node.username
  group node.username
  mode '0644'
  variables(
    :email => node.git.user.email,
    :name => node.git.user.name
  )
end