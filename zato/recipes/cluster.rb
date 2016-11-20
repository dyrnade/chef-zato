include_recipe 'chef-vault'

if !node["zato_cluster_created"]
  zato_secrets = chef_vault_item('secrets','postgresql')
  zato = chef_vault_item('secrets','zato_certs')

  odb_host = ""
  odb_type = "postgresql"
  odb_port = "5432"
  odb_user = zato_secrets['zato_user']
  odb_db_name = zato_secrets['zato_user']
  odb_password = zato_secrets['zato_pass']
  tech_account_name = zato['tech_account_name']
  tech_account_pass = zato['tech_account_pass']
  broker_host = ""
  broker_port = "6379"
  cluster_name = "zato_cluster"
  lb_host = ""
  lb_port = "11223"
  lb_agent_port = "20151"

  results = search(:node, "tags:postgresql AND chef_environment:#{node.chef_environment}")
  results.each do |result|
    odb_host = result['ipaddress']
  end

  results_lb = search(:node, "tags:zato_lb AND chef_environment:#{node.chef_environment}")
  results_lb.each do |result|
    lb_host = result['ipaddress']
  end

  results_broker = search(:node, "tags:redis AND chef_environment:#{node.chef_environment}")
  results_broker.each do |result|
    broker_host = result['ipaddress']
  end

  execute 'zato_odb' do
    user 'zato'
    environment ({'HOME' => '/opt/zato', 'USER' => 'zato' , 'PATH' => "/opt/zato/current/bin:#{ENV['PATH']}"})
    command "zato create odb --odb_host #{odb_host} --odb_port #{odb_port} --odb_user #{odb_user} --odb_db_name #{odb_db_name} --odb_password \"#{odb_password}\"  #{odb_type}"
  end

  execute 'zato_cluster' do
    user 'zato'
    environment ({'HOME' => '/opt/zato', 'USER' => 'zato' , 'PATH' => "/opt/zato/current/bin:#{ENV['PATH']}"})
    command "zato create cluster  --odb_host #{odb_host} --odb_port #{odb_port} \
             --odb_user #{odb_user} --odb_db_name #{odb_db_name} --odb_password \"#{odb_password}\" --tech_account_password #{tech_account_pass} \
             #{odb_type} #{lb_host} #{lb_port} #{lb_agent_port} #{broker_host} #{broker_port} #{cluster_name} #{tech_account_name}"
  end

  node.set["zato_cluster_created"] = true

  tag('zato_cluster')
end
