#
# Cookbook Name:: my_lamp
# Recipe:: httpd
#

# -------------
# ソースからインストール
# 参考: http://qiita.com/k-motoyan/items/fdf6f2768471a5eda0e8
#
# wget http://ftp.yz.yamagata-u.ac.jp/pub/network/apache//httpd/httpd-2.4.10.tar.gz
# tar zxvf 
# cd httpd-2.4.10/srclib
# wget http://ftp.jaist.ac.jp/pub/apache//apr/apr-1.5.1.tar.gz
# wget http://ftp.jaist.ac.jp/pub/apache//apr/apr-util-1.5.4.tar.gz
# tar zxf apr-
# tar zxf apr-util-
# mv apr-1.5.1 apr
# mv apr-util-1.5.4 apr-util
# cd ..
# ./configure --prefix=/usr/local/apache2
# make
# make install
# ln -s /usr/local/apache2/bin/httpd /usr/sbin/httpd
# -----------
# 設定ファイルの場所
# /usr/local/apache2/bin/httpd
# /usr/local/apache2/conf/httpd.conf
# -------------

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