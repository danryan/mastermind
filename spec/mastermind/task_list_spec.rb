require 'spec_helper'

module Mastermind
  describe TaskList do
  
    describe '#tasks' do
      it "should be an array of tasks" do
        task_list = TaskList.new
        task_list.tasks.should be_an Array
      end
      
    end
    
    describe '#add' do
      it "should add a valid task" do
        task_list = TaskList.new
        task = Task.new
        expect { task_list.add(task) }.to_not raise_exception
      end
      
      it "should not add a non-Task object" do
        task_list = TaskList.new
        task = "task"
        expect { task_list.add(task) }.to raise_exception(ArgumentError)
      end
    end
  end
end