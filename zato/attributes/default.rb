default['zato']['platform_etc_dir'] = '/etc/zato'

# zato lb
default['zato']['lb']['tls']['ssl_chain']['path'] = "#{default['zato']['platform_etc_dir']}/ssl/ca.cert"
default['zato']['lb']['tls']['ssl_chain']['name'] = 'ca.cert'
default['zato']['lb']['tls']['ssl_chain']['source'] = 'chef-vault'
default['zato']['lb']['tls']['ssl_chain']['bag'] = 'secrets'
default['zato']['lb']['tls']['ssl_chain']['item'] = 'zato_certs'
default['zato']['lb']['tls']['ssl_chain']['item_key'] = 'zato_cacert'

default['zato']['lb']['tls']['ssl_key']['path'] = "#{default['zato']['platform_etc_dir']}/ssl/lb/load_balancer.key.pem"
default['zato']['lb']['tls']['ssl_key']['source'] = 'chef-vault'
default['zato']['lb']['tls']['ssl_key']['bag'] = 'secrets'
default['zato']['lb']['tls']['ssl_key']['item'] = 'zato_certs'
default['zato']['lb']['tls']['ssl_key']['item_key'] = 'lb_key'

default['zato']['lb']['tls']['ssl_cert']['path'] = "#{default['zato']['platform_etc_dir']}/ssl/lb/load_balancer.key.pub.pem"
default['zato']['lb']['tls']['ssl_cert']['source'] = 'chef-vault'
default['zato']['lb']['tls']['ssl_cert']['bag'] = 'secrets'
default['zato']['lb']['tls']['ssl_cert']['item'] = 'zato_certs'
default['zato']['lb']['tls']['ssl_cert']['item_key'] = 'lb_key_pub'

# lb_cert_path
default['zato_lb_cert_path'] = "#{default['zato']['platform_etc_dir']}/ssl/lb/load_balancer.cert.pem"



# zato server
default['zato']['server']['tls']['ssl_chain']['path'] = "#{default['zato']['platform_etc_dir']}/ssl/ca.cert"
default['zato']['server']['tls']['ssl_chain']['name'] = 'ca.cert'
default['zato']['server']['tls']['ssl_chain']['source'] = 'chef-vault'
default['zato']['server']['tls']['ssl_chain']['bag'] = 'secrets'
default['zato']['server']['tls']['ssl_chain']['item'] = 'zato_certs'
default['zato']['server']['tls']['ssl_chain']['item_key'] = 'zato_cacert'

default['zato']['server']['tls']['ssl_key']['path'] = "#{default['zato']['platform_etc_dir']}/ssl/server/server_key.key.pem"
default['zato']['server']['tls']['ssl_key']['source'] = 'chef-vault'
default['zato']['server']['tls']['ssl_key']['bag'] = 'secrets'
default['zato']['server']['tls']['ssl_key']['item'] = 'zato_certs'
default['zato']['server']['tls']['ssl_key']['item_key'] = 'server_key'

default['zato']['server']['tls']['ssl_cert']['path'] = "#{default['zato']['platform_etc_dir']}/ssl/server/server_key_pub.key.pub.pem"
default['zato']['server']['tls']['ssl_cert']['source'] = 'chef-vault'
default['zato']['server']['tls']['ssl_cert']['bag'] = 'secrets'
default['zato']['server']['tls']['ssl_cert']['item'] = 'zato_certs'
default['zato']['server']['tls']['ssl_cert']['item_key'] = 'server_key_pub'

# server_cert_path
default['zato_server_cert_path'] = "#{default['zato']['platform_etc_dir']}/ssl/server/server_cert.cert.pem"



# zato webadmin
default['zato']['webadmin']['tls']['ssl_chain']['path'] = "#{default['zato']['platform_etc_dir']}/ssl/ca.cert"
default['zato']['webadmin']['tls']['ssl_chain']['name'] = 'ca.cert'
default['zato']['webadmin']['tls']['ssl_chain']['source'] = 'chef-vault'
default['zato']['webadmin']['tls']['ssl_chain']['bag'] = 'secrets'
default['zato']['webadmin']['tls']['ssl_chain']['item'] = 'zato_certs'
default['zato']['webadmin']['tls']['ssl_chain']['item_key'] = 'zato_cacert'

default['zato']['webadmin']['tls']['ssl_key']['path'] = "#{default['zato']['platform_etc_dir']}/ssl/webadmin/webadmin_key.key.pem"
default['zato']['webadmin']['tls']['ssl_key']['source'] = 'chef-vault'
default['zato']['webadmin']['tls']['ssl_key']['bag'] = 'secrets'
default['zato']['webadmin']['tls']['ssl_key']['item'] = 'zato_certs'
default['zato']['webadmin']['tls']['ssl_key']['item_key'] = 'webadmin_key'

default['zato']['webadmin']['tls']['ssl_cert']['path'] = "#{default['zato']['platform_etc_dir']}/ssl/webadmin/webadmin_key_pub.key.pub.pem"
default['zato']['webadmin']['tls']['ssl_cert']['source'] = 'chef-vault'
default['zato']['webadmin']['tls']['ssl_cert']['bag'] = 'secrets'
default['zato']['webadmin']['tls']['ssl_cert']['item'] = 'zato_certs'
default['zato']['webadmin']['tls']['ssl_cert']['item_key'] = 'webadmin_key_pub'

# webadmin_cert_path
default['zato_webadmin_cert_path'] = "#{default['zato']['platform_etc_dir']}/ssl/webadmin/webadmin_cert.cert.pem"
