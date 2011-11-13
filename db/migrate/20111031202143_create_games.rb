class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :username
      t.integer :session_num
      t.integer :game_num
      t.boolean :win
      t.decimal :amount
      t.integer :num_cards
      t.integer :card_count
      t.integer :dealer_count
      t.datetime :date_time

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
