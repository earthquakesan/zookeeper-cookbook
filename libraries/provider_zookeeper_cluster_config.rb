#
# Cookbook: zookeeper-cluster-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
require 'forwardable'

class Chef::Provider::ZookeeperClusterConfig < Chef::Provider::LWRPBase
  include Poise
  extend Forwardable
  def_delegators :@new_resource, :cluster_name, :cluster_node_type, :cluster_node_id

  provides :zookeeper_cluster_config

  action :create do
    directory ZookeeperClusterCookbook::Config.config_directory do
      recursive true
      mode '0644'
      owner run_user
      group run_group
    end

    file ZookeeperCluster::Config.filename(cluster_name) do
      content @new_resource.to_config_file_str
      mode '0644'
      owner run_user
      group run_group
    end
  end

  action :remove do
    file ZookeeperCluster::Config.filename(cluster_name) do
      action :delete
    end
  end
end
