class CreateAactions < ActiveRecord::Migration
  def self.up
    create_table :aactions do |t|
      t.integer :agent_id
      t.string :channel
      t.float :timestamp
      t.integer :queu_id
      t.string :queue_name
      t.float :uniqueid
      t.string :action
      t.string :field1
      t.string :field2
      t.string :field3

      t.timestamps
    end
  end

  def self.down
    drop_table :aactions
  end
end
