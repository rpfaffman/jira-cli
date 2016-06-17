#!/usr/bin/env ruby

require 'optparse'
require_relative '../lib/app'
require_relative '../lib/router'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: jira [options]"

  opts.on("-a", "--assignee [assignee]", Array, "Specify assignee") do |assignee|
    options[:assignee] = assignee
  end

  opts.on("-l", "--labels [labels]", Array, "Specify labels") do |labels|
    options[:labels] = labels
  end

  opts.on("-s", "--status [status]", Array, "Specify status") do |status|
    options[:status] = status
  end

  opts.on("-o", "--order [order]", "Specify order") do |order|
    options[:order] = order
  end
end.parse!

Router.new(App.new).process(ARGV, options)
