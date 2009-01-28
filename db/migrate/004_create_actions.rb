class CreateActions < ActiveRecord::Migration
  def self.up
    create_table :actions do |t|
      t.integer :timestamp,  :limit => 10
      t.string :uniqueid, :limit => 32
      t.string :queue_name, :limit => 32
      t.string :channel, :limit => 45
      t.string :action,  :limit => 32
      t.string :data1, :limit => 255
      t.string :data2, :limit => 255
      t.string :data3, :limit => 255
      t.integer :agent_id, :limit => 12
      t.integer :queu_id, :limit => 12

      t.timestamps
    end
  end

  def self.down
    drop_table :actions
  end
end
