# パッケージ (Node.js)
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

# npmでmochaとchaiをインストール
bash 'add_mocha' do
  user 'root'
  code <<-EOC
    npm install -g mocha chai
  EOC
  not_if 'which mocha'
end