#
# Cookbook Name:: my_lamp
# Recipe:: nodejs
#

# パッケージ (Node.js, JSDoc)
%w{nodejs npm}.each do |p|
  package p do
    action :install
  end
end

# npmでJSDocをインストール
bash 'add_jsdoc' do
  user 'root'
  code <<-EOC
    npm install -g jsdoc
  EOC
  not_if 'which jsdoc'
end