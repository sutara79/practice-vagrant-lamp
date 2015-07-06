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

# npmでmochaをインストール
bash 'add_mocha' do
  user 'root'
  code <<-EOC
    npm install -g mocha
  EOC
  not_if 'which mocha'
end