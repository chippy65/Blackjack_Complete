class AddDealerstuffToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :dealer_game_num, :integer
    add_column :games, :dealer_card_count, :integer
  end

  def self.down
    remove_column :games, :dealer_card_count
    remove_column :games, :dealer_game_num
  end
end
