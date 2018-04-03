class UsersController < ApplicationController
  before_action :find_user, only: [:find]
  before_action :set_user, only: [:edit, :update, :add_technical_coach, :set_technical_coach]
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
      @user.is_admin? ? nil : @user.add_admin_role
    else
      @user.is_admin? ? @user.destroy_admin_role : nil
    end

    if @user.is_technical_coach? && params["technical_coach"] != "1"
      @user.destroy_technical_coach_role
    end

    if @user.roles.empty?
      flash[:warning] = "#{@user.name} has no roles." unless params["technical_coach"] == "1"
    else
      flash[:warning] = "#{@user.name} has been given #{@user.list_roles}." unless params["technical_coach"] == "1"
    end

    if params["technical_coach"] == "1" && !@user.is_technical_coach?
      redirect_to add_technical_coach_path(@user.username)
    else
      redirect_to add_user_path(@user.username)
    end
  end

  def add_technical_coach
    @role = @user.roles.build
  end

  def set_technical_coach
    @user.add_technical_coach_role(params["role"]["technical_coach_id"])
    if @user.is_technical_coach?
      flash[:warning] = "#{@user.name} has been given #{@user.list_roles}."
      redirect_to add_user_path(@user.username)
    else
      flash[:warning] = "something went wrong"
      redirect_to add_technical_coach_path(@user.username)
    end
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
