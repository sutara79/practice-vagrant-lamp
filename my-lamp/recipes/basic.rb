# iptables無効 (ファイアウォール)
# なお、selinux(細かなアクセス制御)ははじめから無効になっているので特に操作する必要はない。
service 'iptables' do
  action [:stop, :disable]
end

# パッケージ (基本)
# mlocate 管理作業用
# lsof 管理作業用
%w{wget libyaml libyaml-devel mlocate lsof}.each do |p|
  package p do
    action :install
  end
end