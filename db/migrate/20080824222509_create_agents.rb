class CreateAgents < ActiveRecord::Migration
  def self.up
    create_table :agents do |t|
      t.string :channel
      t.string :first
      t.string :last
      t.string :exten
      t.integer :group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :agents
  end
end
