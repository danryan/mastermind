require 'spec_helper'

describe Mastermind::Plot do
  let(:attrs_hash) do
    {
      "name" => "foobar", 
      "tasks"=> {
        "test[foo]" => { 
          "action" => "run", 
          "name" => "foo", 
          "message" => "FOO", 
          "resource_name" => "test"
        },
        "test[bar]" => {
          "action"=>"run", 
          "name"=>"bar",
          "message" => "BAR",
          "resource_name" => "test"
        }
      }
    }
  end
  let(:plot) { Mastermind::Plot.new(attrs_hash) }
  
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
