require 'spec_helper'

describe Mastermind::Plot do
  let(:plot) { Mastermind::Plot.new(:name => "foo") }

  let(:plot_hash) do
    {"name" => "foo", "tasks"=>[]}
  end
  let(:plot_json) do
    "{\"name\":\"foo\",\"tasks\":[]}"
  end

  let(:full_plot) do
    Mastermind::Plot.new(
      :name => "foo",
      :tasks => [
        Mastermind::Resource::Mock.new(:name => "foo"),
        Mastermind::Resource::Mock.new(:name => "bar")
      ]
    )
  end
  let(:full_plot_hash) do
    {
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
          "message" => nil
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
          "message" => nil
        }
      ]
    }
  end
  let(:full_plot_json) do
    "{\"name\":\"foo\",\"tasks\":[{\"resource_name\":\"mock\",\"default_action\":\"run\",\"action\":null,\"name\":\"foo\",\"not_if\":null,\"only_if\":null,\"on_success\":[],\"on_failure\":[],\"provider_name\":\"mock\",\"message\":null},{\"resource_name\":\"mock\",\"default_action\":\"run\",\"action\":null,\"name\":\"bar\",\"not_if\":null,\"only_if\":null,\"on_success\":[],\"on_failure\":[],\"provider_name\":\"mock\",\"message\":null}]}"
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

  #describe '#new' do
    
    #it "should accept a name attribute" do
      #plot = Plot.new(:name => "infrastructure")
      #plot.name.should == "infrastructure"
    #end
    
    #it "should raise an error if no name is specified" do
      #plot = Plot.new
      #lambda { plot.save }.should raise_error Mastermind::ValidationError
    #end
    
    #it "should have an empty task list" do
      #plot = Plot.new(:name => "servers")
      #plot.tasks.length.should == 0
    #end
    
    #context "if a tasks hash is supplied" do
      #it "should convert tasks hash to a hash of Resource objects" do
        #plot.tasks.should have(2).items
        #plot.tasks['test[foo]'].should be_an_instance_of Mastermind::Resource::Test
      #end
    #end
  #end
  
  #describe "#save" do
    #it "should generate an id" do
      #plot.save
      #plot.id.should_not be_nil
    #end
    
    #it "should save to the database" do
      #plot.save
      #plot2 = Mastermind::Plot.find(plot.id)
      #plot2.tasks.should have(2).items
      #plot2.tasks['test[foo]'].should be_an_instance_of Mastermind::Resource::Test
    #end
  #end
  
  #describe ".find" do
    #it "should find plots by id" do
      #plot.save
      #plot2 = Mastermind::Plot.find(plot.id)
      #plot2.should_not be_nil
    #end
  #end
  
  #describe '#tasks' do
    #it "should return a Hash" do
      #plot = Plot.new(:name => "servers")
      #plot.tasks.should be_a Hash
    #end
  #end
end
