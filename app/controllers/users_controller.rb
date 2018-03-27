class UsersController < ApplicationController
  before_action :find_user, only: [:find]
  
  def search

  end
  
  def find
    if @user
      flash.discard
      redirect_to add_user_path(@user.username)
    else
      flash[:error] = "User not found"
      render :search
    end
  end

  def edit
  end

  def update
  end

  private
    def find_user
      @user = User.all.find{|user| user.username.downcase == params[:username].downcase}
    end
end
