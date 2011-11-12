require 'spec_helper'

describe Provider do
  let(:attributes) { { :foo => "bar" } }
  let(:resource) { Resource::Mock.new(:name => "foo", :message => "FOO") }
  let(:provider) { Provider::Mock.new(attributes.merge(:resource => resource)) }


  describe "validation" do

    it "is valid with required attributes" do
      puts provider.new_resource.to_hash.inspect
      
      provider.should be_valid
      provider.provider_name.should == "mock"
      provider.actions.should == ["run", "fail"]
      provider.options.should == { "foo" => "bar" }
    end

  end
  
  describe "type conversion" do
    let(:provider_hash) do
      {"provider_name"=>"mock", "actions"=>["run", "fail"], "foo"=>"bar"}
    end
    let(:provider_json) do
      "{\"provider_name\":\"mock\",\"actions\":[\"run\",\"fail\"],\"foo\":\"bar\"}"
    end
    
    describe "#to_hash" do
      it "returns a Hash" do
        provider.to_hash.should be_a Hash
        provider.to_hash.should == provider_hash
      end
    end

    describe "#to_json" do
      it "returns a JSON string" do
        provider.to_json.should be_a String
        provider.to_json.should == provider_json
      end
    end

    describe ".from_hash" do
      it "converts a Hash into a Provider object" do
        provider = Provider.from_hash(provider_hash)
        provider.actions.should == ["run", "fail"]
        provider.provider_name.should == "mock"
      end
    end

    describe ".from_json" do
      it "converts a JSON string into a Provider object" do
        provider = Provider.from_json(provider_json)
        provider.actions.should == ["run", "fail"]
        provider.provider_name.should == "mock"
      end
    end

    describe "#to_s" do
      it "returns a String" do
        provider.to_s.should == "provider[mock]"
      end
    end

  end

  describe "attributes" do
    describe "#provider_name" do
      it "returns the provider name" do
        provider.provider_name.should == "mock"
      end
    end

    describe "#actions" do
      it "returns the valid actions" do
        provider.actions.should == ["run", "fail"]
      end
    end

  end
end
