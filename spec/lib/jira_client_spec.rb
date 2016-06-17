require_relative '../../lib/jira_client.rb'

describe JiraClient do
  let(:client) {
    JiraClient.new(
      jira_uri: jira_uri,
      base_query: base_query,
      email: email,
      password: password,
      api: api
    )
  }

  let(:jira_uri) { 'http://teamcoco.atlassian.net' }
  let(:base_query) { 'assignee="Arthur Dent"' }
  let(:email) { 'someone@somewhere.net' }
  let(:password) { 'password123' }
  let(:api) { double('api') }
  let(:headers) do
    {
      "Authorization" => "Basic #{auth_string}",
      "Content-Type" => "application/json"
    }
  end
  let(:auth_string) { Base64.encode64("#{email}:#{password}").delete("\n") }
  let(:expected_issues) { ["issue1", "issue2"] }

  describe "#string_query" do
    let(:full_path) { "#{jira_uri}/rest/api/2/search?jql=#{escaped_query_string}" }
    let(:query_string) { 'labels in ("web")' }
    let(:escaped_query_string) { URI.escape("#{base_query} and #{query_string}") }
    let(:query_response) do { "issues" => expected_issues } end

    before do
      allow(api).to receive(:get).with(
        full_path,
        headers: headers,
        body: {}.to_json
      ) { { "issues" => expected_issues } }
    end

    it "should send a GET request with the JQL query" do
      expect(client.string_query(query_string)).to eq(expected_issues)
    end

    describe "query is nil" do
      let(:escaped_query_string) { URI.escape("#{base_query}") }

      before do
        allow(api).to receive(:get).with(
          full_path,
          headers: headers,
          body: {}.to_json
        ) { { "issues" => expected_issues } }
      end

      it "should send a GET request with base query only" do
        expect(client.string_query(nil)).to eq(expected_issues)
      end
    end
  end

  describe "#options_query" do
    let(:options) do
      {
        labels: ['refactor', 'zombies'],
        status: ['to do']
      }
    end
    let(:full_path) { "#{jira_uri}/rest/api/2/search?jql=#{escaped_query_string}" }
    let(:escaped_query_string) {
      URI.escape("#{base_query} and labels in ('refactor', 'zombies') and status in ('to do')")
    }

    before do
      allow(api).to receive(:get).with(
        full_path,
        headers: headers,
        body: {}.to_json
      ) { { "issues" => expected_issues } }
    end

    it "should send a GET request with the options as a JQL query" do
      expect(client.options_query(options)).to eq(expected_issues)
    end
  end

  describe "#update_status" do
    let(:issue_key) { "key" }
    let(:status) { "done" }
    let(:transition_path) { "#{jira_uri}/rest/api/2/issue/#{issue_key}/transitions" }
    let(:transition_id) { 42 }
    let(:expected_response) { 'successful response' }

    before do
      allow(api).to receive(:get).with(
        transition_path,
        headers: headers,
        body: {}.to_json
      ) do
        { "transitions" => [ { "name" => status, "id" => transition_id } ] }
      end

      allow(api).to receive(:post).with(
        transition_path,
        headers: headers,
        body: { transition: { id: transition_id } }.to_json
      ) { expected_response }
    end

    it "should send a POST request to change the issue status" do
      expect(client.update_status(issue_key, status)).to eq(expected_response)
    end
  end

  describe "#open_issue" do
    let(:issue_key) { 'AB-123' }
    let(:git_branch_name) { 'XY-987' }

    describe "issue_key is provided" do
      it "should `open` the jira URI of the provided key" do
        expect(client).to receive(:system).with("open #{jira_uri}/browse/#{issue_key}")
        client.open_issue(issue_key)
      end
    end
  end
end
