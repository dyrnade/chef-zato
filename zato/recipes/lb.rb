include_recipe 'chef-vault'

load_balancer_path = '/opt/zato/load_balancer'

directory File.dirname(node.default['zato']['lb']['tls']['ssl_cert']['path']) do
  recursive true
  owner 'zato'
  group 'zato'
end

certificate = ssl_certificate 'zato_lb' do
  owner 'zato'
  group 'zato'
  namespace node['zato']['lb']['tls']
end

pub_key_path = certificate.cert_path
priv_key_path = certificate.key_path
ca_certs_path = certificate.chain_path


zato_certs =  chef_vault_item("secrets", "zato_certs")
cert_path = node.default['zato_lb_cert_path']
file node.default['zato_lb_cert_path'] do
  content zato_certs['lb_cert']
  mode '0644'
  owner 'zato'
  group 'zato'
end

directory load_balancer_path do
  owner 'zato'
  group 'zato'
  mode '0755'
  action :create
end

execute 'zato_lb' do
  user 'zato'
  environment ({'HOME' => '/opt/zato', 'USER' => 'zato' , 'PATH' => "/opt/zato/current/bin:#{ENV['PATH']}"})
  command "zato create load_balancer #{load_balancer_path} #{pub_key_path} #{priv_key_path} #{cert_path} #{ca_certs_path}"
  on_failure {notify :run, 'execute[zato_lb_del]'}
  not_if {::File.exists?("#{load_balancer_path}")}
end

service "zato" do
  service_name  "zato"
  action        :nothing
end

link '/etc/zato/components-enabled/load_balancer' do
  to load_balancer_path
  notifies :restart, "service[zato]"
end

service "zato" do
  action :restart
end

tag('zato_lb')
