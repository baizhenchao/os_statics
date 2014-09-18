#! ruby
require 'spec_helper'

describe NodeOs_Statics do
		include Rack::Test::Methods
		def app
				NodeOs_Statics
		end

    # 有空补充下测试用例
		it "should get hello" do
				get "/centos/"
				expect(last_response.body).to eq "Hello"
		end
end
