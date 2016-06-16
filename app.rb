#!/usr/bin/env ruby

require 'yaml'
require 'optparse'

require_relative './lib/jira_client'
require_relative './lib/printer'

class App
  def query(options)
    query_method = options.is_a?(Hash) ? :options_query : :query
    issues = client.public_send(query_method, options)
    printer.display_issues(issues)
  end

  def transition(key, options)
    response = client.update_status(key, options[:status].first)
    printer.display_response(response)
  end

  private

  def client
    @client ||= JiraClient.new(
      jira_uri: config["JIRA_URI"],
      base_query: config["BASE_QUERY"],
      email: config["EMAIL"],
      password: config["PASSWORD"]
    )
  end

  def printer
    @printer ||= Printer.new
  end

  def config
    @config ||= YAML::load_file(File.join(__dir__, 'config.yml'))
  end
end

class Router
  attr_reader :client

  def initialize(client)
    @client = client
  end

  def process(args, options={})
    case (args[0] && args[0].downcase)
    when "update"
      client.public_send(:update, args[1], options)
    when "transition"
      client.public_send(:transition, args[1], options)
    else # default to query
      args = options.any? ? options : args[0]
      client.public_send(:query, args)
    end
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: jira [options]"

  opts.on("-s", "--status [status]", Array, "Specify status") do |status|
    options[:status] = status
  end

  opts.on("-l", "--label [label]", Array, "Specify label") do |label|
    options[:label] = label
  end
end.parse!

Router.new(App.new).process(ARGV, options)
