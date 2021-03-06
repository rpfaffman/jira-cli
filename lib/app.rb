require 'yaml'
require_relative './jira_client'
require_relative './display'
require_relative './models/issue'

class App
  # query using jql or flags
  # TODO: allow query string AND options. build query from options
  # and concatenate the two strings
  def query(query)
    query_method = query.is_a?(Hash) ? :options_query : :string_query
    issues = client.public_send(query_method, query).map{ |json| Models::Issue.new(json) }
    display.print_issues(issues)
  end

  # transition state of issue
  def transition(key, args)
    response = client.update_status(key, args.first)
    display.print_response(response)
  end

  # open ticket in browser
  def open(key, options={})
    client.open(key)
  end

  def watch(key, options={})
    response = client.watch(key)
    display.print_response(response)
  end

  def unwatch(key, options={})
    response = client.unwatch(key)
    display.print_response(response)
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

  def display
    @display ||= Display.new
  end

  def config
    @config ||= YAML::load_file(File.join(__dir__, '../config.yml'))
  end
end

