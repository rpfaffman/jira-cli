require_relative '../../lib/router.rb'

describe Router do
  let(:router) { Router.new(app) }
  let(:app) { double('app') }

  describe "#process" do
    describe "default" do
      before { allow(app).to receive(:query) }

      describe "options provided" do
        let(:args) { [] }
        let(:options) do { status: 'in review' } end

        it "should call query on the app with the provided options hash" do
          expect(app).to receive(:query).with(options)
          router.process(args, options)
        end
      end
      
      describe "string argument provided" do
        let(:args) { [ "labels in ('code-review')" ] }
        let(:options) do {} end

        it "should call query on the app with the provided string argument" do
          expect(app).to receive(:query).with(args.first)
          router.process(args, options)
        end
      end
    end

    describe "update" do
      let(:args) { [ "update", issue_key ] }
      let(:issue_key) { "AB-123" }
      let(:options) do { fields: { some_field: 42} } end

      before { allow(app).to receive(:update) }

      it "should call update with the issue_key and options" do
        expect(app).to receive(:update).with(issue_key, options)
        router.process(args, options)
      end
    end

    describe "transition" do
      let(:args) { [ "transition", issue_key ] }
      let(:issue_key) { "AB-123" }
      let(:options) do { status: "done" } end

      before { allow(app).to receive(:transition) }

      it "should call update with the issue_key and options" do
        expect(app).to receive(:transition).with(issue_key, options)
        router.process(args, options)
      end
    end
  end
end
