require 'yaml'
require_relative 'jira_client'
require_relative 'printer'

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
    @config ||= YAML::load_file(File.join(__dir__, '../config.yml'))
  end
end

