class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.references :definition
      t.text :fields, :default =>  {}.to_json
      t.text :last_results, :default =>  {}.to_json
      t.string :last_wfid
      t.string :state
      
      t.timestamps
      t.datetime :last_failure_at
      t.datetime :last_success_at
      t.datetime :last_canceled_at
    end
  end
end
