class CreateAgents < ActiveRecord::Migration
  def self.up
    create_table :agents do |t|
      t.string :channel, :limit => 45
      t.string :first, :limit => 16
      t.string :last, :limit => 16
      t.string :exten, :limit => 12
      t.integer :group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :agents
  end
end
