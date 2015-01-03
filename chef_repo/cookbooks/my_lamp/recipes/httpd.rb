#
# Cookbook Name:: my_lamp
# Recipe:: httpd
#

# パッケージ (Apache)
package 'httpd' do
  action :install
end

# 設定ファイル (共有フォルダのマウント後にhttpdを起動するため)
cookbook_file '/etc/init/httpd.conf' do
  source 'httpd.conf'
  mode '0644'
end

# 設定ファイル (Welcomeページの表示を阻止)
cookbook_file '/etc/httpd/conf.d/welcome.conf' do
  source 'welcome.conf'
  mode '0644'
end

# 設定ファイル (httpd)
template '/etc/httpd/conf/httpd.conf' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :allow_override => 'All', # for mod_rewrite
    :enable_mmap => 'Off',
    :enable_sendfile => 'Off'
  )
  notifies :reload, 'service[httpd]'
end