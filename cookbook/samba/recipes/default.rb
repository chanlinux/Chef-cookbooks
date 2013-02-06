#
# Cookbook Name:: samba
# Recipe:: default
#
array=Array.new
pkgs=value_for_platform(
	["centos","redhat","fedora"] => { "default" => ["samba","samba-common","samba-client"]},
	["ubuntu"]=> { "default" => ["samba","samclient","smbfs"]}
)

pkgs.each do |packs|
	package packs
end

service "smb" do
  supports :status => true, :restart => true, :reload => true
  action :enable
end

shares = data_bag_item("samba", node[:samba][:sharename])
shares["shares"].each do |k,v|
        array << v
end

template "/etc/samba/smb.conf" do
    source "smb.conf.erb"
    owner "root"
    group "root"
    mode 00644
    variables ( {:data => array})
    notifies :restart,"service[smb]"
end

