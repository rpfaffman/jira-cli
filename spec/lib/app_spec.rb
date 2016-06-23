require_relative '../../lib/app.rb'

describe App do
  let(:app) { App.new }
  let(:options) do { some_key: "some value" } end
  let(:issues) { [issue1, issue2] }
  let(:issues_json) { [issue1_json, issue2_json] }
  let(:issue1) { double('issue1') }
  let(:issue2) { double('issue2') }
  let(:issue1_json) do { some: 'data for issue1' } end
  let(:issue2_json) do { some: 'data for issue2' } end

  before do
    allow(Models::Issue).to receive(:new).with(issue1_json) { issue1 }
    allow(Models::Issue).to receive(:new).with(issue2_json) { issue2 }
    allow_any_instance_of(JiraClient)
      .to receive(:options_query) { issues_json }
    allow_any_instance_of(Display)
      .to receive(:print_issues) { true }
  end

  describe "#query" do
    it "should print the results" do
      expect_any_instance_of(Display)
        .to receive(:print_issues).with(issues)
      app.query(options)
    end

    describe "query arg is a hash" do
      it "should send the options to the client" do
        expect_any_instance_of(JiraClient)
          .to receive(:options_query).with(options)
        app.query(options)
      end
    end

    describe "query arg is a string" do
      let(:query_string) { 'additional query' }

      before do
        allow_any_instance_of(JiraClient)
          .to receive(:query) { issues_json }
      end

      it "should send the options to the client" do
        expect_any_instance_of(JiraClient)
          .to receive(:query).with("and #{query_string}")
        app.query(query_string)
      end
    end
  end

  describe "#transition" do
    let(:response) { double('response') }
    let(:key) { 'AB-123' }
    let(:args) { [ status ] }
    let(:status) { 'in progress' }

    before do
      allow_any_instance_of(JiraClient)
        .to receive(:update_status) { response } 
      allow_any_instance_of(Display)
        .to receive(:print_response) { true }
    end

    it "should update status" do
      expect_any_instance_of(JiraClient)
        .to receive(:update_status).with(key, status)
      app.transition(key, args)
    end

    it "should print the response" do
      expect_any_instance_of(Display)
        .to receive(:print_response).with(response)
      app.transition(key, args)
    end
  end

  describe "#open" do
    let(:key) { 'AB-123'}

    it "should open the issue with the client" do
      expect_any_instance_of(JiraClient)
        .to receive(:open_issue).with(key)
      app.open(key)
    end
  end
end
