#
# Cookbook Name:: my_lamp
# Recipe:: git
#

# 古いパッケージを削除
package 'git' do
  action :remove
end

# 依存ライブラリ
# 参照: http://git-scm.com/book/en/v2/Getting-Started-Installing-Git
%w{curl-devel expat-devel gettext-devel openssl-devel zlib-devel}.each do |p|
  package p do
    action :install
  end
end

# ソースからインストール
bash 'install-git' do
  user 'root'
  code <<-EOC
    wget https://www.kernel.org/pub/software/scm/git/#{node.git.version}.tar.gz
    tar zxf #{node.git.version}.tar.gz
    cd #{node.git.version}
    ./configure --prefix=/usr
    make all
    make install
  EOC
  not_if 'which git'
end

# 設定ファイル
template "/home/#{node.username}/.gitconfig" do
  owner node.username
  group node.username
  mode '0644'
  variables(
    :email => node.git.user.email,
    :name => node.git.user.name
  )
end