class TcsController < ApplicationController
  @@tcs_data = TcStarRatingAdapter.get_ratings

  def index
    @tcs_data = @@tcs_data
    # binding.pry
    @tcs = @tcs_data.map {|tc| [tc.first, slug(tc.first)]}
  end

  def show
    @tcs_data = @@tcs_data
    @tc_name = params[:slug]
    binding.pry
    @tc = find_by_slug(@tcs_data, params[:slug])
    # @tc_name =
  end

  def slug(name)
    slug_name = name.gsub(/[^a-zA-Z]/,'-').downcase
  end

  def find_by_slug(data, slug)
    binding.pry
    data.find {|a| a.first.first.slug === slug}
  end

end
