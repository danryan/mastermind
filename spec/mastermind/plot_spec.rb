require 'spec_helper'

module Mastermind
  describe Plot do
    describe '#new' do
      
      it "should accept a name" do
        plot = Plot.new("infrastructure")
        plot.name.should == "infrastructure"
      end
      
      it "should raise an error when no name is specified" do
        expect { Plot.new }.to raise_error(ArgumentError)
      end
      
      it "should have an empty task list" do
        plot = Plot.new("servers")
        plot.tasks.length.should == 0
      end
    end
    
    describe '#tasks' do
      it "should return a TaskList" do
        plot = Plot.new("servers")
        plot.tasks.should be_a TaskList
      end
    end
  end
end