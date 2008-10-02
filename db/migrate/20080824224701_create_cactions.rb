class CreateCactions < ActiveRecord::Migration
  def self.up
    create_table :cactions do |t|
      t.integer :call_id
      t.float :timestamp
      t.float :uniqueid
      t.integer :agent_id
      t.integer :queu_id
      t.string :queue_name
      t.string :channel
      t.string :action
      t.string :field1
      t.string :field2
      t.string :field3

      t.timestamps
    end
  end

  def self.down
    drop_table :cactions
  end
end
