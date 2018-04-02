class UsersController < ApplicationController
  before_action :find_user, only: [:find]
  before_action :set_user, only: [:edit, :update]
  before_action :authorize_user!
  
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
    if params["admin"] == "1"
      @user.is_admin? ? nil: @user.add_admin_role
    else
      @user.is_admin? ? @user.destroy_admin_role : nil
    end

    if @user.roles.empty?
      flash[:warning] = "#{@user.name} has no roles."
    else
      flash[:warning] = "#{@user.name} has been given #{@user.list_roles}."
    end
    redirect_to add_user_path(@user.username)
  end

  private
    def find_user
      @user = User.all.find{|user| user.username.downcase == params[:username].downcase}
    end

    def set_user
      @user = User.find_by(username: params[:username])
    end

    def authorize_user!
      redirect_to root_path if !current_user || !current_user.is_admin?
    end
end
