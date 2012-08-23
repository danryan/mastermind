class CreateDefinitions < ActiveRecord::Migration
  def change
    create_table :definitions do |t|
      t.text   :definition
      t.string :name
      t.timestamps
    end
  end
end
