class CreateQueus < ActiveRecord::Migration
  def self.up
    create_table :queus do |t|
      t.string :queue_name, :limit => 25
      t.string :exten, :limit => 12
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :queus
  end
end
