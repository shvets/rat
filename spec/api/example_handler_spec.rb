require File.dirname(__FILE__) + '/api_spec_helper'

describe Handler::Example do
  include_context "ApiTest"

  describe "#example" do
    it "returns example message" do
      response = subject.example

      response[:message].should_not be_blank
    end
  end

end