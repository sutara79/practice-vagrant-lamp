#
# Cookbook Name:: my_lamp
# Recipe:: git
#

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
  creates "/#{node.git.version}"
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