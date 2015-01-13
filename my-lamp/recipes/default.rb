include_recipe "#{cookbook_name}::basic"
include_recipe "#{cookbook_name}::httpd"
include_recipe "#{cookbook_name}::mysql"
include_recipe "#{cookbook_name}::pgsql"
include_recipe "#{cookbook_name}::php"
include_recipe "#{cookbook_name}::nodejs"
include_recipe "#{cookbook_name}::ruby"

# Apacheの起動
service 'httpd' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end