require_relative '../../lib/app.rb'

describe App do
  let(:app) { App.new }
  let(:options) do { some_key: "some value" } end
  let(:issues) { ['issue1', 'issue2'] }

  before do
    allow_any_instance_of(JiraClient)
      .to receive(:options_query) { issues }
    allow_any_instance_of(Printer)
      .to receive(:display_issues) { true }
  end

  describe "#query" do
    it "should print the results" do
      expect_any_instance_of(Printer)
        .to receive(:display_issues).with(issues)
      app.query(options)
    end

    describe "query is nil" do
      it "should use the base query" do
        expect_any_instance_of(JiraClient)
          .to receive(:string_query).with(nil)
        app.query(nil)
      end
    end

    describe "query arg is a hash" do
      it "should send the options to the client" do
        expect_any_instance_of(JiraClient)
          .to receive(:options_query).with(options)
        app.query(options)
      end
    end

    describe "query arg is a string" do
      let(:query_string) { "string" }

      before do
        allow_any_instance_of(JiraClient)
          .to receive(:query) { issues }
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
    let(:options) do
      { status: [ status ] }
    end
    let(:status) { 'in progress' }

    before do
      allow_any_instance_of(JiraClient)
        .to receive(:update_status) { response } 
      allow_any_instance_of(Printer)
        .to receive(:display_response) { true }
    end

    it "should update status" do
      expect_any_instance_of(JiraClient)
        .to receive(:update_status).with(key, status)
      app.transition(key, options)
    end

    it "should print the response" do
      expect_any_instance_of(Printer)
        .to receive(:display_response).with(response)
      app.transition(key, options)
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
