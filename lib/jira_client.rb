require 'httparty'

class JiraClient
  attr_reader :jira_uri, :base_query, :email, :password, :api

  def initialize(opts)
    @jira_uri = opts.fetch(:jira_uri)
    @base_query = opts.fetch(:base_query)
    @email = opts.fetch(:email)
    @password = opts.fetch(:password)
    @api = opts.fetch(:api, HTTParty)
  end

  def options_query(options)
    query(build_query(options))
  end

  def string_query(string)
    query_str = base_query && string ? "and #{string}" : string
    query(query_str)
  end

  def query(str)
    query_str = [base_query, str].compact.join(" ")
    request(:get, "search?jql=" + URI.escape(query_str))["issues"]
  end

  def update_status(key, status)
    response = request(:get, "issue/#{key}/transitions")
    transition_id = response["transitions"].find do |transition|
      transition["name"].downcase === status.downcase
    end["id"]
    request(
      :post,
      "issue/#{key}/transitions",
      transition: { id: transition_id } 
    )
  end

  def open_issue(key=nil)
    issue_key = key || git_branch
    system("open #{jira_uri}/browse/#{issue_key}")
  end

  private

  def request(method, path, data={})
    full_path = "#{base_uri}/#{path}"
    api.public_send(method, full_path, headers: headers, body: data.to_json)
  end

  def build_query(options)
    query = []
    order = options.delete(:order)
    options.each { |k, v| query.push("#{k} in ('#{v.join("\', \'")}')") }
    query_string = query.any? ? "and #{query.join(" and ")}" : ""
    query_string += " order by #{(order)}" if order
    !query_string.empty? ? query_string : nil
  end

  def base_uri
    "#{jira_uri}/#{api_path}"
  end

  def api_path
    "rest/api/2"
  end

  def headers
    {
      "Authorization" => "Basic #{auth_string}",
      "Content-Type" => "application/json"
    }
  end

  def auth_string
    @auth_string ||= Base64.encode64("#{email}:#{password}").delete("\n")
  end

  def git_branch
    `git status | head -n 1 | cut -d ' ' -f 3`.delete("\n")
  end
end
