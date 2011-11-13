class AddDealersessionumToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :dealer_session_num, :integer
  end

  def self.down
    remove_column :games, :dealer_session_num
  end
end
