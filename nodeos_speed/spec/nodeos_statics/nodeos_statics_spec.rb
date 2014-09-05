#! ruby
require 'spec_helper'

describe NodeOs_Statics do
		include Rack::Test::Methods
		def app
				NodeOs_Statics
		end

		it "should get hello" do
				get "/centos/"
				expect(last_response.body).to eq "Hello"
		end
end
