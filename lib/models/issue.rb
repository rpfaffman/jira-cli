module Models
  class Issue
    attr_reader :key, :summary, :status, :reporter,
      :assignee, :labels, :description, :json_uri, :jira_uri

    def initialize(json)
      fields = json["fields"]
      @key = json["key"]
      @summary = fields["summary"]
      @status = fields["status"]["name"]
      @reporter = fields["reporter"]["name"]
      @assignee = fields["assignee"]["name"] if fields["assignee"]
      @labels = fields["labels"]
      @description = fields["description"]
      @json_uri = json["self"]
      @jira_uri = "https://vevowiki.atlassian.net/browse/#{json["key"]}"
    end
  end
end
