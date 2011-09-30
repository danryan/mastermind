require 'spec_helper'

describe Mastermind::Plot do
  let(:plot) { Mastermind::Plot.new(:name => "foo") }
  let(:full_plot) do
    Mastermind::Plot.new(
      :name => "foo",
      :tasks => [
        Mastermind::Resource::Mock.new(:name => "foo", :message => "FOO!"),
        Mastermind::Resource::Mock.new(:name => "bar", :message => "BAR!")
      ]
    )
  end
  let(:plot_hash) do
    {"id" => nil, "name" => "foo", "tasks"=>[]}
  end
  let(:plot_json) do
    "{\"id\":null,\"name\":\"foo\",\"tasks\":[]}"
  end
  let(:full_plot_hash) do
    {
      "id" => nil,
      "name" => "foo", 
      "tasks" => [
        {
          "resource_name" => "mock",
          "default_action" => "run",
          "action" => nil,
          "name" => "foo",
          "not_if" => nil,
          "only_if" => nil,
          "on_success" => [],
          "on_failure" => [],
          "provider_name" => "mock", 
          "message" => "FOO!"
        }, 
        {
          "resource_name" => "mock",
          "default_action" => "run",
          "action" => nil,
          "name" => "bar",
          "not_if" => nil,
          "only_if" => nil,
          "on_success" => [],
          "on_failure" => [],
          "provider_name" => "mock",
          "message" => "BAR!"
        }
      ]
    }
  end
  let(:saved_plot_hash) do
    {
      "id" => 1,
      "name" => "foo", 
      "tasks" => [
        {
          "resource_name" => "mock",
          "default_action" => "run",
          "action" => nil,
          "name" => "foo",
          "not_if" => nil,
          "only_if" => nil,
          "on_success" => [],
          "on_failure" => [],
          "provider_name" => "mock", 
          "message" => "FOO!"
        }, 
        {
          "resource_name" => "mock",
          "default_action" => "run",
          "action" => nil,
          "name" => "bar",
          "not_if" => nil,
          "only_if" => nil,
          "on_success" => [],
          "on_failure" => [],
          "provider_name" => "mock",
          "message" => "BAR!"
        }
      ]
    }
  end
  let(:full_plot_json) do
    "{\"id\":null,\"name\":\"foo\",\"tasks\":[{\"resource_name\":\"mock\",\"default_action\":\"run\",\"action\":null,\"name\":\"foo\",\"not_if\":null,\"only_if\":null,\"on_success\":[],\"on_failure\":[],\"provider_name\":\"mock\",\"message\":\"FOO!\"},{\"resource_name\":\"mock\",\"default_action\":\"run\",\"action\":null,\"name\":\"bar\",\"not_if\":null,\"only_if\":null,\"on_success\":[],\"on_failure\":[],\"provider_name\":\"mock\",\"message\":\"BAR!\"}]}"
  end
  let(:saved_plot_json) do
    "{\"id\":1,\"name\":\"foo\",\"tasks\":[{\"resource_name\":\"mock\",\"default_action\":\"run\",\"action\":null,\"name\":\"foo\",\"not_if\":null,\"only_if\":null,\"on_success\":[],\"on_failure\":[],\"provider_name\":\"mock\",\"message\":null},{\"resource_name\":\"mock\",\"default_action\":\"run\",\"action\":null,\"name\":\"bar\",\"not_if\":null,\"only_if\":null,\"on_success\":[],\"on_failure\":[],\"provider_name\":\"mock\",\"message\":null}]}"
  end

  describe "conversions" do

    describe "#to_hash" do
      it "returns a Hash" do
        plot.to_hash.should be_a Hash
        plot.to_hash.should == plot_hash    
      end

      it "returns a Hash with task objects" do
        full_plot.to_hash.should == full_plot_hash
      end

    end
    
    describe "#to_json" do
      it "returns a JSON string" do
        plot.to_json.should be_a String
        plot.to_json.should == plot_json    
      end

      it "returns a JSON string with task objects" do
        full_plot.to_json.should == full_plot_json        
      end
    end

    describe ".from_hash" do
      it "converts a Hash to a Plot" do
        plot = Mastermind::Plot.from_hash(plot_hash)
        plot.name.should == "foo"
        plot.tasks.should be_empty
      end

      it "converts a Hash with tasks to a Plot" do
        plot = Mastermind::Plot.from_hash(full_plot_hash)
        plot.name.should == "foo"
        plot.tasks.first.should be_a Mastermind::Resource
      end
    end

    describe ".from_json" do
      it "converts a JSON string to a Plot" do
        plot = Mastermind::Plot.from_json(plot_json)
        plot.name.should == "foo"
        plot.tasks.should be_empty
      end

      it "converts a JSON string with tasks to a Plot" do
        plot = Mastermind::Plot.from_json(full_plot_json)
        plot.name.should == "foo"
        plot.tasks.first.should be_a Mastermind::Resource
      end
    end

    describe "#to_s" do
      it "returns a String" do
        plot.to_s.should == "plot[foo]"
      end
    end
  end  

  describe '#new' do
    
    it "starts with an empty task list" do
      plot = Mastermind::Plot.new(:name => "servers")
      plot.tasks.length.should == 0
    end
    
  end
  
  describe "#save" do
    it "generates an id" do
      plot.save
      plot.id.should_not be_nil
    end
    
    it "saves to the database" do
      full_plot.save
      plot2 = Mastermind::Plot.find(full_plot.id)
      plot2.tasks.should have(2).items
      plot2.tasks.first.should be_a Mastermind::Resource
    end

    it "raises an error if invalid" do
      plot = Mastermind::Plot.new
      lambda { plot.save }.should raise_error Mastermind::ValidationError
    end

  end
  
  describe ".find" do
    it "should find plots by id" do
      plot.save
      plot2 = Mastermind::Plot.find(plot.id)
      plot2.should_not be_nil
    end
  end
  
  describe '#tasks' do
    it "returns an array of Resources" do
      full_plot.tasks.should be_an Array
      full_plot.tasks.first.should be_a Mastermind::Resource
    end
  end
end
