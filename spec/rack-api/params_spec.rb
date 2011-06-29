require "spec_helper"

describe Rack::API, "Params" do
   before do
    Rack::API.app do
      version :v1 do
        get("users/:id(.:format)") { params }
        post("users") { params }
      end
    end
  end

  it "detects optional names from routing params" do
    get "/v1/users/1.json"
    json(last_response.body).should == {"id" => "1", "format" => "json"}
  end

  it "detects query string params" do
    get "/v1/users/1?include=articles"
    json(last_response.body).should == {"id" => "1", "include" => "articles"}
  end

  it "detects post params" do
    post "/v1/users", :name => "John Doe"
    last_response.body.should == {"name" => "John Doe"}.to_json
  end

  it "detects post params when running inside a rails app" do
    post "/v1/users", {}, { "action_dispatch.request.request_parameters" => { :name => "John Doe" } }
    last_response.body.should == {"name" => "John Doe"}.to_json
  end
end
