class RemoveDealercardcountFromGame < ActiveRecord::Migration
  def self.up
    remove_column :games, :dealer_card_count
  end

  def self.down
    add_column :games, :dealer_card_count, :integer
  end
end
