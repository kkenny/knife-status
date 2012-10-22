require 'chef/knife'
require 'highline'

module Limelight
  class NodeStatus < Chef::Knife

    deps do
      require 'chef/search/query'
      require 'chef/knife/search'
    end

    banner "knife node status NODE"

    def h
      @highline ||= HighLine.new
    end

    def run
      unless @node_name = name_args[0]
        ui.error "You need to specify a node"
        exit 1
      end

      searcher = Chef::Search::Query.new
      result = searcher.search(:node, "name:#{@node_name}")

      knife_search = Chef::Knife::Search.new
      node = result.first.first
      if node.nil?
        puts "Could not find a node named #{@node_name}"
        exit 1
      end

      $stdout.sync = true

      if node[:status]
        log_entries = [ h.color('Time', :bold, :underline),
                        h.color('Status', :bold, :underline),
                        h.color('Start Time', :bold, :underline),
                        h.color('End Time', :bold, :underline),
                        h.color('Run Time', :bold, :underline) ]
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
