class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :definition
      t.text :fields
      t.text :result
      t.string :last_wfid
      t.string :state
      
      t.timestamps
    end
  end
end
