class TcsController < ApplicationController

  def index
    @tcs_data = TcStarRatingAdapter.get_ratings
    @tcs = @tcs_data.map {|tc| tc.first}
  end

  def show

  end

end