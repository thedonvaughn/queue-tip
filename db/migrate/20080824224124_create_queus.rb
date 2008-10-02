class CreateQueus < ActiveRecord::Migration
  def self.up
    create_table :queus do |t|
      t.string :queue_name
      t.string :exten
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :queus
  end
end
