require 'spec_helper'

describe Task do
  let(:task) { Task.new(:name => "foo") }
  let(:full_task) do
    Task.new(
      :name => "foo",
      :resources => [
        Resource::Mock.new(:name => "foo", :message => "FOO!"),
        Resource::Mock.new(:name => "bar", :message => "BAR!")
      ]
    )
  end
  let(:task_hash) do
    {"name" => "foo", "resources"=>[]}
  end
  let(:task_json) do
    "{\"name\":\"foo\",\"resources\":[]}"
  end
  let(:full_task_hash) do
    {
      "name" => "foo", 
      "resources" => [
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
  let(:full_task_json) do
    "{\"name\":\"foo\",\"resources\":[{\"resource_name\":\"mock\",\"default_action\":\"run\",\"action\":null,\"name\":\"foo\",\"not_if\":null,\"only_if\":null,\"on_success\":[],\"on_failure\":[],\"provider_name\":\"mock\",\"message\":\"FOO!\"},{\"resource_name\":\"mock\",\"default_action\":\"run\",\"action\":null,\"name\":\"bar\",\"not_if\":null,\"only_if\":null,\"on_success\":[],\"on_failure\":[],\"provider_name\":\"mock\",\"message\":\"BAR!\"}]}"
  end

  describe "conversions" do

    describe "#to_hash" do
      it "returns a Hash" do
        task.to_hash.should be_a Hash
        task.to_hash.should == task_hash    
      end

      it "returns a Hash with task objects" do
        full_task.to_hash.should == full_task_hash
      end

    end
    
    describe "#to_json" do
      it "returns a JSON string" do
        task.to_json.should be_a String
        task.to_json.should == task_json    
      end

      it "returns a JSON string with task objects" do
        full_task.to_json.should == full_task_json        
      end
    end

    describe ".from_hash" do
      it "converts a Hash to a Task" do
        task = Task.from_hash(task_hash)
        task.name.should == "foo"
        task.resources.should be_empty
      end

      it "converts a Hash with resources to a Task" do
        task = Task.from_hash(full_task_hash)
        task.name.should == "foo"
        task.resources.first.should be_a Resource
      end
    end

    describe ".from_json" do
      it "converts a JSON string to a Task" do
        task = Task.from_json(task_json)
        task.name.should == "foo"
        task.resources.should be_empty
      end

      it "converts a JSON string with resources to a Task" do
        task = Task.from_json(full_task_json)
        task.name.should == "foo"
        task.resources.first.should be_a Resource
      end
    end

    describe "#to_s" do
      it "returns a String" do
        task.to_s.should == "task[foo]"
      end
    end
  end  

  describe '#new' do
    
    it "starts with an empty task list" do
      task = Task.new(:name => "servers")
      task.resources.length.should == 0
    end
    
  end
  
  # describe "#save" do
  #     it "generates an id" do
  #       task.save
  #       task.id.should_not be_nil
  #     end
  #     
  #     it "saves to the database" do
  #       full_task.save
  #       task2 = Task.find(full_task.id)
  #       task2.resources.should have(2).items
  #       task2.resources.first.should be_a Resource
  #     end
  # 
  #     it "raises an error if invalid" do
  #       task = Task.new
  #       lambda { task.save }.should raise_error ValidationError
  #     end
  # 
  #   end
  
  # describe ".find" do
  #   it "should find tasks by id" do
  #     task.save
  #     task2 = Task.find(task.id)
  #     task2.should_not be_nil
  #   end
  # end
  
  describe '#resources' do
    it "returns an array of Resources" do
      full_task.resources.should be_an Array
      full_task.resources.first.should be_a Resource
    end
  end
end
