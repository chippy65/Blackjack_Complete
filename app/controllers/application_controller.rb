class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :current_player

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    begin
      @current_user_session = UserSession.find
    rescue
      @current_user_session = UserSession.first
    end
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def current_player
    return @current_player if defined?(@current_player)
    @current_player = current_user_session.record
  end
end
