require File::join(File::dirname(__FILE__), "../spec_helper")

$:.unshift(File.expand_path('../../lib',  __FILE__))

require 'rat_api'

describe Rat::API do
  include Rack::Test::Methods

  let(:app) { Rat::API }

  describe "GET /api/example" do
    it "returns example message as json" do
      get "/api/example.json"

      last_response.status.should == 200

      result = JSON.parse(last_response.body)
      result["message"].should_not be_blank
    end

    it "returns example message as xml" do
      get "/api/example.xml"

      last_response.status.should == 200

      result = Nokogiri::XML(last_response.body)
      result.search("message").first.content.should_not be_blank
    end
  end
end
