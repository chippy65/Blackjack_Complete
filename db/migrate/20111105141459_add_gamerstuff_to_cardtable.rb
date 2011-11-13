class AddGamerstuffToCardtable < ActiveRecord::Migration
  def self.up
    add_column :cardtables, :player, :text
    add_column :cardtables, :dealer, :text
    add_column :cardtables, :deck, :text
    add_column :cardtables, :bet, :decimal
  end

  def self.down
    remove_column :cardtables, :bet
    remove_column :cardtables, :deck
    remove_column :cardtables, :dealer
    remove_column :cardtables, :player
  end
end
