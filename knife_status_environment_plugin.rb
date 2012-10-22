require 'chef/knife'
require 'highline'

module Limelight
  class EnvironmentStatus < Chef::Knife

    deps do
      require 'chef/search/query'
      require 'chef/knife/search'
    end

    banner "knife environment status ENVIRONMENT"

    def h
      @highline ||= HighLine.new
    end

    def run
      unless @env_name = name_args[0]
        ui.error "You need to specify an environment"
        exit 1
      end

      searcher = Chef::Search::Query.new
      result = searcher.search(:environment, "name:#{@env_name}")

      knife_search = Chef::Knife::Search.new
      environment = result.first.first
      if environment.nil?
        puts "Could not find an environment named #{@env_name}"
        exit 1
      end

      nodes = searcher.search(:node, "chef_environment:#{environment}").first
      if nodes.nil?
	puts "Could not find any nodes for the environment #{environment}"
	exit 1
      end

      count = nodes.count
      i = 0
      node_names = []
      while i < count do
	node_names[i] = nodes[i].name
	i = i + 1
      end

      node_names.each do |n|
	node = searcher.search(:node, "name:#{n}").first.first
	puts node.name
	1.upto(node.name.length) { print "-" }
	puts

	$stdout.sync = true

	if node[:status]
	  log_entries = [ h.color('Time', :bold),
                        h.color('Status', :bold),
                        h.color('Start Time', :bold),
                        h.color('End Time', :bold),
                        h.color('Run Time', :bold) ]
	  node[:status].each do |log_entry|
	    log_entries << log_entry[:time].to_s
	    log_entries << log_entry[:status].to_s
	    log_entries << log_entry[:start_time].to_s
	    log_entries << log_entry[:end_time].to_s
	    log_entries << log_entry[:run_time].to_s
	  end
        puts h.list(log_entries, :columns_across, 5)
        puts
        end
      end
    end
  end
end
