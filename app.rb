#!/usr/bin/env ruby

require 'httparty'
require 'json'
require_relative './colors'
require 'yaml'

class JiraClient
  attr_reader :api

  def initialize
    @api = HTTParty
  end

  def query(jql, params={})
    query_string = base_query + jql
    response = api.get("#{base_uri}/search?jql=" + + URI.escape(query_string), headers: headers, query: params)
    print_issues(response["issues"])
    puts "QUERY: #{query_string}".green
    puts "RESULTS: #{response["issues"].count}".green
  end

  private

  def print_issues(issues)
    # use 'tput cols' bash command to get width of screen
    col_num = `tput cols`

    issues.each do |issue|
      fields = issue["fields"]
      puts "=" * col_num.to_i
      print "(#{issue['key']}) #{fields['summary']}".brown.underline, " "
      puts "[#{fields['status']['name']}] ".blue
      puts "TAGS: #{fields['labels'].join(', ').green}"
      puts "DESCRIPTION: #{fields['description']}"
      puts "URI: #{"https://vevowiki.atlassian.net/browse/#{issue['key']}".cyan}"
    end

    puts "=" * col_num.to_i
  end

  def config
    @config ||= YAML::load_file(File.join(__dir__, 'config.yml'))
  end

  def headers
    {
      "Authorization" => "Basic #{auth_string}",
      "Content-Type" => "application/json"
    }
  end

  def base_query
    config["BASE_QUERY"]
  end

  def base_uri
    "#{config['JIRA_URI']}/rest/api/2"
  end

  def auth_string
    @auth_string ||= Base64.encode64("#{config["EMAIL"]}:#{config["PASSWORD"]}").delete("\n")
  end
end

JQL = (ARGV.any? ? " and #{ARGV.join(" ")}" : "")
JiraClient.new.query(JQL)

