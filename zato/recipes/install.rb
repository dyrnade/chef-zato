##
# Cookbook Name:: zato
# Recipe:: default
##

include_recipe 'apt'
case node['platform']
  when "debian","ubuntu"
    package ['apt-transport-https' ,'python-software-properties' ,'software-properties-common'] do
      action :install
    end

    apt_repository 'zato' do
      uri          'https://zato.io/repo/stable/2.0/debian'
      key          'https://zato.io/repo/zato-0CBD7F72.pgp.asc'
      components   ['main']
    end

    package "zato" do
      action :install
    end

  when "redhat","centos"

    yum_repository 'zato' do
      description 'Extra Packages for Enterprise Linux'
      mirrorlist 'https://zato.io/repo/stable/2.0/rhel/el$releasever/$basearch'
      gpgkey 'https://zato.io/repo/zato-0CBD7F72.pgp.asc'
      action :create
    end

    execute 'expire-cache' do
      command 'yum clean expire-cache'
    end

    execute 'expire-cache' do
      command 'yum check-update'
    end

    package "zato" do
      action :install
    end
end
