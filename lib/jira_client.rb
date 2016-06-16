require 'httparty'

class JiraClient
  attr_reader :jira_uri, :base_query, :email, :password, :api

  def initialize(opts)
    @jira_uri = opts[:jira_uri]
    @base_query = opts[:base_query]
    @email = opts[:email]
    @password = opts[:password]
    @api = HTTParty
  end

  def options_query(options)
    query(build_query(options))
  end

  def query(str)
    query_str = [base_query, str].compact.join(" and ")
    request(:get, "search?jql=" + URI.escape(query_str))["issues"]
  end

  def update_status(issue_key, status)
    response = request(:get, "issue/#{issue_key}/transitions")
    transition_id = response["transitions"].find do |transition|
      transition["name"].downcase === status.downcase
    end["id"]
    request(
      :post,
      "issue/#{issue_key}/transitions",
      transition: { id: transition_id } 
    )
  end

  private

  def request(method, path, data={})
    full_path = "#{base_uri}/#{path}"
    api.public_send(method, full_path, headers: headers, body: data.to_json)
  end

  def build_query(options)
    query = []
    query.push(label_query(options[:label])) if options[:label]
    query.push(status_query(options[:status])) if options[:status]
    query.join(" and ")
  end

  def label_query(labels)
    "labels in ('#{labels.join("\', \'")}')"
  end

  def status_query(statuses)
    "status in ('#{statuses.join("\', \'")}')"
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
end
