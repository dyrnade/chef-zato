# Run first these Dependicies : postgresql::ulakbus, database::zato, redismulti::master, zato::odb

include_recipe 'chef-vault'

results_cluster = search(:node, "tags:zato_cluster AND chef_environment:#{node.chef_environment}")


if !node["zato_server_created"] and results_cluster[0]
  zato_secrets = chef_vault_item('secrets','postgresql')

  odb_host = ""
  odb_type = "postgresql"
  odb_port = "5432"
  odb_user = zato_secrets['zato_user']
  odb_db_name = zato_secrets['zato_user']
  odb_password = zato_secrets['zato_pass']
  server_path = "/opt/zato/server"
  cluster_name = "zato_cluster"
  kvdb_host = ""
  kvdb_port = "6379"
  server_name = "zato_server"

  results = search(:node, "tags:postgresql AND chef_environment:#{node.chef_environment}")
  results.each do |result|
    odb_host = result['ipaddress']
  end

  results_kv = search(:node, "tags:redis AND chef_environment:#{node.chef_environment}")
  results_kv.each do |result|
    kvdb_host = result['ipaddress']
  end


  directory File.dirname(node.default['zato']['server']['tls']['ssl_cert']['path']) do
    recursive true
    owner 'zato'
    group 'zato'
  end

  certificate = ssl_certificate 'zato_server' do
    owner 'zato'
    group 'zato'
    namespace node['zato']['server']['tls']
  end

  pub_key_path = certificate.cert_path
  priv_key_path = certificate.key_path
  ca_certs_path = certificate.chain_path


  zato_certs =  chef_vault_item("secrets", "zato_certs")
  cert_path = node.default['zato_server_cert_path']
  file node.default['zato_server_cert_path'] do
    content zato_certs['server_cert']
    mode '0644'
    owner 'zato'
    group 'zato'
  end


  directory server_path do
    owner 'zato'
    group 'zato'
    mode '0755'
    action :create
  end

  execute 'zato_server' do
    user 'zato'
    environment ({'HOME' => '/opt/zato', 'USER' => 'zato' , 'PATH' => "/opt/zato/current/bin:#{ENV['PATH']}"})
    command "zato create server  --odb_host #{odb_host} --odb_port #{odb_port} \
             --odb_user #{odb_user} --odb_db_name #{odb_db_name} --odb_password \"#{odb_password}\" --kvdb_password '' \
             #{server_path} #{odb_type} #{kvdb_host} #{kvdb_port} #{pub_key_path} #{priv_key_path} #{cert_path} \
             #{ca_certs_path} #{cluster_name} #{server_name}"
  end

  service "zato" do
    service_name  "zato"
    action        :nothing
  end

  link '/etc/zato/components-enabled/server' do
    to server_path
    notifies :restart, "service[zato]"
  end

  tag('zato_server')

end
