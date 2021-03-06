#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

include_recipe "mysql::server"


if node[:ec2]

  service "mysql" do
    action :stop
    not_if do 
      FileTest.directory?(node[:mysql][:ec2_path]) 
    end
  end

  execute "install-mysql" do
    command "mv #{node[:mysql][:datadir]} #{node[:mysql][:ec2_path]}"
    not_if do 
      FileTest.directory?(node[:mysql][:ec2_path]) 
    end
  end

  directory node[:mysql][:datadir] do
    owner "mysql"
    group "mysql"
  end

  mount node[:mysql][:datadir] do
    device node[:mysql][:ec2_path]
    fstype "none"
    options "bind,rw"
    action :mount

    notifies :restart, resources(:service => :mysql )
  end


end

