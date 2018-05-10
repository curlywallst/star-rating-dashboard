class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:home]

  def home
    render '/home'
  end

  private
  def authorize_user!
     redirect_to root_path if !current_user || !current_user.is_admin?
  end
end
