class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.string :definition
      t.text :fields, default: {}.to_json
      t.text :results, default: {}.to_json
      t.string :last_wfid
      t.string :state
      
      t.timestamps
      t.datetime :last_failure_at
      t.datetime :last_success_at
    end
  end
end
