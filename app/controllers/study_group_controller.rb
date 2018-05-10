class StudyGroupController < ApplicationController
  before_action :set_months
  
  def index
    @month = "All"
    StudyGroupStarRatingAdapter.get_ratings
  end

  def show
    StudyGroupStarRatingAdapter.get_ratings
    @tc = TechnicalCoach.find_by_slug(params[:slug])
  end

  def search
    @month = params.to_unsafe_h[:month]
    render :index
  end

  private
    def set_months
      @months = [
        "All",
        "January", "February", "March", "April",
        "May", "June", "July", "August",
        "September", "October", "November", "December"
      ]
    end
end
