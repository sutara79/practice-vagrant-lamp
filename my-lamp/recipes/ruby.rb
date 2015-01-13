# dependency: wget

package 'ruby' do
  action :install
end

# Heroku Toolbeltをインストール
bash 'add-heroku-toolbelt' do
  user 'root'
  code <<-EOC
    wget -x https://toolbelt.heroku.com/install.sh
    cd toolbelt.heroku.com
    echo 'PATH="/usr/local/heroku/bin:$PATH"' >> /etc/profile
    source /etc/profile
    sh install.sh
  EOC
  not_if 'which heroku'
end