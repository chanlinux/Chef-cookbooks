#
# Cookbook Name:: samba
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
array=Array.new
pkgs=value_for_platform(
	["centos","redhat","fedora"] => { "default" => ["samba","samba-common","samba-client"]},
	["ubuntu"]=> { "default" => ["samba"]}
)

pkgs.each do |packs|
	package packs
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
end

service "smb" do
	action :nothing
end
