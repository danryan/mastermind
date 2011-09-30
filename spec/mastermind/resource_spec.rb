require 'spec_helper'

describe Mastermind::Resource do
  let(:valid_attributes) { { :name => "foo", :message => "Running!" } }
  let(:invalid_attributes) { { :name => "bar" } }
  let(:resource) { Mastermind::Resource::Mock.new(valid_attributes) }
  let(:invalid_resource) { Mastermind::Resource::Mock.new(invalid_attributes) }

  describe "validation" do

    it "is valid with required attributes" do
      resource = Mastermind::Resource::Mock.new(valid_attributes)
      resource.should be_valid
      resource.name.should == "foo"
      resource.message.should == "Running!"
    end

    it "is invalid without required attributes" do
      invalid_resource = Mastermind::Resource::Mock.new(invalid_attributes)
      invalid_resource.should_not be_valid
    end
  end
  
  describe "type conversion" do
    let(:resource_hash) do
      {
        "default_action" => "run", 
        "provider_name" => "mock",
        "action" => nil,
        "name" => "foo",
        "not_if" => nil,
        "only_if" => nil,
        "on_success" => [],
        "on_failure"=> [], 
        "resource_name" => "mock",
        "message" => "Running!"
      }
    end
    let(:resource_json) do
      "{\"resource_name\":\"mock\",\"default_action\":\"run\",\"action\":null,\"name\":\"foo\",\"not_if\":null,\"only_if\":null,\"on_success\":[],\"on_failure\":[],\"provider_name\":\"mock\",\"message\":\"Running!\"}"
    end
    
    describe "#to_hash" do
      it "returns a Hash" do
        resource.to_hash.should be_a Hash
        resource.to_hash.should == resource_hash
      end
    end

    describe "#to_json" do
      it "returns a JSON string" do
        resource.to_json.should == resource_json
      end
    end

    describe ".from_hash" do
      it "converts a Hash into a Resource object" do
        resource = Mastermind::Resource.from_hash(resource_hash)
        resource.name.should == "foo"
        resource.message.should == "Running!"
        resource.provider_name.should == "mock"
      end
    end

    describe ".from_json" do
      it "converts a JSON string into a Resource object" do
        resource = Mastermind::Resource.from_hash(resource_hash)
        resource.name.should == "foo"
        resource.message.should == "Running!"
        resource.provider_name.should == "mock"
      end
    end

    describe "#to_s" do
      it "returns a String" do
        resource.to_s.should == "mock[foo]"
      end
    end
  end

  describe "attributes" do
    describe "#provider" do
      it "returns the class of the resource's provider" do
        resource.provider.should == Mastermind::Provider::Mock
      end
    end

    describe "#provider_name" do
      it "returns the provider name" do
        resource.provider_name.should == "mock"
      end
    end

    describe "#resource_name" do
      it "returns the resource name" do
        resource.resource_name.should == "mock"
      end
    end
    
  end

  describe "execution" do
    it "executes successfully when resource is valid" do
      $stdout.should_receive(:puts).with(/Running/)
      resource.execute(:run)
    end

    it "raises an error when resource is missing attributes" do
      lambda { invalid_resource.execute(:run) }.
        should raise_error(Mastermind::ValidationError)
    end

  end
end
