include_recipe 'chef-vault'

results_cluster = search(:node, "tags:zato_cluster AND chef_environment:#{node.chef_environment}")

if !node["zato_webadmin_created"] and results_cluster[0]
  zato_secrets = chef_vault_item('secrets','postgresql')
  zato = chef_vault_item('secrets','zato_certs')

  odb_host = ""
  odb_type = "postgresql"
  odb_port = "5432"
  odb_user = zato_secrets['zato_user']
  odb_db_name = zato_secrets['zato_user']
  odb_password = zato_secrets['zato_pass']
  web_admin_path = "/opt/zato/webadmin"
  tech_account_name = zato['tech_account_name']
  tech_account_pass = zato['tech_account_pass']

  results = search(:node, "tags:postgresql AND chef_environment:#{node.chef_environment}")
  results.each do |result|
    odb_host = result['ipaddress']
  end

  # install ssl certs

  directory File.dirname(node.default['zato']['webadmin']['tls']['ssl_cert']['path']) do
    recursive true
    owner 'zato'
    group 'zato'
  end

  certificate = ssl_certificate 'zato_webadmin' do
    owner 'zato'
    group 'zato'
    namespace node['zato']['webadmin']['tls']
  end

  pub_key_path = certificate.cert_path
  priv_key_path = certificate.key_path
  ca_certs_path = certificate.chain_path


  zato_certs =  chef_vault_item("secrets", "zato_certs")
  cert_path = node.default['zato_webadmin_cert_path']
  file node.default['zato_webadmin_cert_path'] do
    content zato_certs['webadmin_cert']
    mode '0644'
    owner 'zato'
    group 'zato'
  end

  directory "#{web_admin_path}".to_s do
    owner 'zato'
    group 'zato'
    mode '0755'
    action :create
  end

    execute 'zato_webadmin' do
      user 'zato'
      environment ({'HOME' => '/opt/zato', 'USER' => 'zato' , 'PATH' => "/opt/zato/current/bin:#{ENV['PATH']}"})
      command "zato create web_admin  --odb_host #{odb_host} --odb_port #{odb_port} \
               --odb_user #{odb_user} --odb_db_name #{odb_db_name} --odb_password \"#{odb_password}\" --tech_account_password #{tech_account_pass} \
              #{web_admin_path} #{odb_type} #{pub_key_path} #{priv_key_path} #{cert_path} \
               #{ca_certs_path} #{tech_account_name}"
    end


  service "zato" do
    service_name  "zato"
    action        :nothing
  end

  link '/etc/zato/components-enabled/webadmin' do
    to web_admin_path
    notifies :restart, "service[zato]"
  end

  node.set["zato_webadmin_created"] = true

  tag('zato_webadmin')

end
