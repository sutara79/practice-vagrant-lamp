#
# Cookbook Name:: my_lamp
# Recipe:: ruby
#
# dependency: make, wget

# Rubyをインストール
bash 'add_ruby' do
  user 'root'
  code <<-EOC
    wget ftp://ftp.ruby-lang.org/pub/ruby/#{node.ruby.version}.tar.gz
    tar xvzf #{node.ruby.version}.tar.gz
    cd #{node.ruby.version}
    ./configure
    make
    make install
    gem install foreman
  EOC
  creates "/#{node.ruby.version}"
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
  creates "/usr/local/heroku"
end