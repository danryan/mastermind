class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.text :tasks
      t.text :fields
      
      t.timestamps
      t.datetime :last_failure_at
      t.datetime :last_success_at
    end
  end
end
