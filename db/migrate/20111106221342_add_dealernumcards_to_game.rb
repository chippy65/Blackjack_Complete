class AddDealernumcardsToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :dealer_num_cards, :integer
  end

  def self.down
    remove_column :games, :dealer_num_cards
  end
end
