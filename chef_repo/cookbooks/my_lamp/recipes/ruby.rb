#
# Cookbook Name:: my_lamp
# Recipe:: ruby
#
# 依存: basic

# Rubyをインストール
ruby_ver = 'ruby-2.1.5'
bash 'add_ruby' do
  user 'root'
  code <<-EOC
    wget ftp://ftp.ruby-lang.org/pub/ruby/#{ruby_ver}.tar.gz
    tar xvzf #{ruby_ver}.tar.gz
    cd #{ruby_ver}
    ./configure
    make
    make install
  EOC
end

# Heroku Toolbeltをインストール
bash 'add_heroku_toolbelt' do
  user 'root'
  code <<-EOC
    wget -x https://toolbelt.heroku.com/install.sh
    cd toolbelt.heroku.com
    echo 'PATH="/usr/local/heroku/bin:$PATH"' >> /etc/profile
    source /etc/profile
    sh install.sh
  EOC
end