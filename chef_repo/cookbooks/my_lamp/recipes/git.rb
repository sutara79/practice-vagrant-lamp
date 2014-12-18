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
git_ver = 'git-2.2.0'
bash 'install_git' do
  user 'root'
  code <<-EOC
    wget https://www.kernel.org/pub/software/scm/git/#{git_ver}.tar.gz
    tar zxvf #{git_ver}.tar.gz
    cd #{git_ver}
    ./configure –-prefix=/usr/local/ --with-curl --with-expat
    make prefix=/usr/local all
    make prefix=/usr/local install
  EOC
end