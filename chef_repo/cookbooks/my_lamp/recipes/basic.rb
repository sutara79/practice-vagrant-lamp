#
# Cookbook Name:: my_lamp
# Recipe:: basic
#

# iptables無効 (ファイアウォール)
# なお、selinux(細かなアクセス制御)ははじめから無効になっているので特に操作する必要はない。
service 'iptables' do
    action [:stop, :disable]
end

# パッケージ (基本)
%w{wget gcc make libyaml libyaml-devel}.each do |p|
  package p do
    action :install
  end
end

# SSH公開鍵を作成
username = 'vagrant'
bash 'ssh-keygen' do
  user username
  code <<-EOC
    ssh-keygen -t rsa -q -f /home/#{username}/.ssh/id_rsa -P ""
  EOC
  creates "/home/#{username}/.ssh/id_rsa.pub"
end