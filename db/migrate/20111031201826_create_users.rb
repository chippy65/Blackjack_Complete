class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.integer :games_played
      t.integer :games_lost
      t.integer :games_won
      t.decimal :balance
      t.decimal :cashflow
      t.integer :num_sessions
      t.integer :games_per_session_avg

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
