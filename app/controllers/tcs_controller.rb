class TcsController < ApplicationController

  def index
    @tcs_data = TcStarRatingAdapter.get_ratings
    @tcs = @tcs_data.map {|tc| tc.first}
  end

  def show
    @tcs_data = TcStarRatingAdapter.get_ratings
    @tc = @tcs_data.find{|tc| tc.second["slug"] == params[:slug]}
  end
end
