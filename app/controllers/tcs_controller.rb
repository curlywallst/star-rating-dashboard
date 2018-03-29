class TcsController < ApplicationController
  @@tcs_data = TcStarRatingAdapter.get_ratings

  def index
    @tcs_data = @@tcs_data
    @tcs = @tcs_data.map {|tc| tc.first}
  end

  def show
    @tcs_data = @@tcs_data
    # @tc_name = params[:slug]

    @tc = @tcs_data.find{|tc| tc.second["slug"] == params[:slug]}
    # @tc_name =
  end
end
