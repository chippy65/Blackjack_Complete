class CardtableController < ApplicationController

  def setupgame

    # Delete any records that are in the table. Even if we have deleted them
    # after each game, the player may start a new game without finishing a
    # previous game normally, i.e. by repeatedly selecting "Start New..."
    Cardtable.delete_all

    # Create a new cardtable and initialise
    @cardtable = Cardtable.new
    @cardtable.startup(current_player)

    # Save this instance so we can get it and use it again
    @cardtable.save

    # Show the state of the table before we start the game
    respond_to do |format|
      format.html {render :action => "default" }
    end
  end

  def playgame

    # There should only be one record in the database as there's only one
    # cardtable session in progress at any one time
    @cardtable = Cardtable.first

    # Find out which button was hit and perform the appropriate action
    if params[:submit] == "Deal"
      @cardtable.deal
    elsif params[:submit] == "Hit"
      @cardtable.hit
    elsif params[:submit] == "Stand"
      @cardtable.stand
    elsif params[:submit] == "Double"
      @cardtable.double
    elsif params[:submit] == "Shuffle"
      @cardtable.shuffle
    elsif params[:submit] == "Deal For The Dealer"
      @cardtable.goDealer
    elsif params[:submit] == "<"
      @cardtable.setBet(@cardtable.bet - 1)
    elsif params[:submit] == ">"
      @cardtable.setBet(@cardtable.bet + 1)
    end

    # Save this instance so we can get it and use it again
    @cardtable.save

    respond_to do |format|
      format.html {render :action => "default" }
    end
  end
end
