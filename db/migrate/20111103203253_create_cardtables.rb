class CreateCardtables < ActiveRecord::Migration
  def self.up
    create_table :cardtables do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :cardtables
  end
end
