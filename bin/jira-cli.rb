#!/usr/bin/env ruby

require 'optparse'
require_relative '../lib/app'
require_relative '../lib/router'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: jira [options]"

  opts.on("-l", "--label [label]", Array, "Specify label") do |label|
    options[:label] = label
  end

  opts.on("-s", "--status [status]", Array, "Specify status") do |status|
    options[:status] = status
  end

  opts.on("-o", "--order [order]", "Specify order") do |order|
    options[:order] = order
  end
end.parse!

Router.new(App.new).process(ARGV, options)
