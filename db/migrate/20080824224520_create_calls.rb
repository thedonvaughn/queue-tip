class CreateCalls < ActiveRecord::Migration
  def self.up
    create_table :calls do |t|
      t.string :cid
      t.integer :queu_id
      t.string :queue_name
      t.float :timestamp
      t.string :uniqueid
      t.integer :agent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :calls
  end
end
