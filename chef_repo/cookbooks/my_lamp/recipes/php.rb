#
# Cookbook Name:: my_lamp
# Recipe:: php
#
# dependency: libyaml, httpd, git

# レポジトリを追加 (PHP用)
bash 'add_repo_remi' do
  user 'root'
  code <<-EOC
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
  EOC
  creates '/etc/yum.repos.d/remi.repo'
end

# パッケージ (PHP5.6系)
%w{php php-common php-mbstring php-xml php-devel php-process php-cli php-pear php-mysql phpmyadmin}.each do |p|
  package p do
    action :install
    options '--enablerepo=remi --enablerepo=remi-php56'
  end
end

# Composerをインストール
bash 'add_composer' do
  user 'root'
  code <<-EOC
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
  EOC
  creates "/usr/local/bin/composer/composer.phar"
end

# PECLでYamlをインストール
bash 'add_pecl_yaml' do
  user 'root'
  code <<-EOC
    pecl install yaml
  EOC
  creates '/usr/lib64/php/modules/yaml.so'
end

# PEARでphpDocumentorをインストール
bash 'add_pear_phpDocumentor' do
  user 'root'
  code <<-EOC
    pear channel-discover pear.phpdoc.org
    pear install phpdoc/phpDocumentor
  EOC
  creates '/usr/bin/phpdoc'
end

# パッケージ (Phalcon用: pcre-devel)
package 'pcre-devel' do
  action :install
end

# gitでcphalconをインストール
bash 'add_cphalcon' do
  user 'root'
  code <<-EOC
    cd /home/vagrant
    git clone git://github.com/phalcon/cphalcon.git
    cd cphalcon/build
    ./install
  EOC
  creates '/usr/lib64/php/modules/phalcon.so'
end

# 設定ファイル (php)
template '/etc/php.ini' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :timezone => node.php.timezone,
    :ext_yaml => 'extension=yaml.so',
  )
  notifies :reload, 'service[httpd]'
end

# 設定ファイル (phpMyAdmin)
template '/etc/httpd/conf.d/phpMyAdmin.conf' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :allow_from => node.php.allow_from
  )
  notifies :reload, 'service[httpd]'
end

# 設定ファイル (phpMyAdmin その2)
template '/etc/phpMyAdmin/config.inc.php' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :auth_type => 'cookie',
    :allow_no_password => 'TRUE'
  )
  notifies :reload, 'service[httpd]'
end