class TcsController < ApplicationController
  @@tcs_data = TcStarRatingAdapter.get_ratings

  def index
    @tcs_data = @@tcs_data
    @tcs = @tcs_data.map {|tc| tc.first}
  end

  def show
    @tcs_data = @@tcs_data
    @tc_name = params[:slug]
    @tc = @tcs_data[@tc_name]
  end

  def slug(name)
    slug_name = name.gsub(/[^a-zA-Z]/,'-').downcase
  end

  # def find_by_slug(slug)
  #   @tcs_data.find {|a| a.first.slug === slug}
  # end

end
