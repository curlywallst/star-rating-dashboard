require 'json'

class TcStarRatingAdapter
  TYPEFORM_TOKEN_KEY = "TYPEFORM_TOKEN"

  def self.ratings  #(form_id)
    form_id = 'TW4DdU'
    @@typeform_token = ENV[TYPEFORM_TOKEN_KEY]
    JSON.parse(fetch_responses(form_id).body)
  end

  def self.get_ratings
    ratings_data = TcStarRatingAdapter.ratings['items']
    @tcs_data = []
    ratings_data.each do |tc_data|
      tc = {}
      if name_and_rating_exist(tc_data)
        tc[:name] = tc_data['answers'].select { |response| response['field']['id'] == "64196466"}[0]['choices']['labels'][0]
        tc[:rating] = tc_data['answers'].select { |response| response['field']['id'] == "MIWlzH1BLFWb"}[0]['number']
        if student_added_comment(tc_data)
          tc[:comment] = tc_data["answers"].find {|response| response['field']['id'] == "ummCANBFwJ5i"}["text"]
        end

        @tcs_data << tc
      end
    end
    aggregate(@tcs_data)
  end

  def self.aggregate(array)
    @tcs_ratings = {}
    array.each do |tc|
      if @tcs_ratings.keys.include?(tc[:name])
        @tcs_ratings["#{tc[:name]}"]["count"] += 1
        @tcs_ratings["#{tc[:name]}"]["cummulative_rating"] += tc[:rating]
        @tcs_ratings["#{tc[:name]}"]["rating"] = @tcs_ratings["#{tc[:name]}"]["cummulative_rating"].to_f / @tcs_ratings["#{tc[:name]}"]["count"].to_f.round(2)
        @tcs_ratings["#{tc[:name]}"]["distribution"][tc[:rating]-1] += 1
        if @tcs_ratings["#{tc[:name]}"]["comments"].keys.include?(tc[:rating].to_s)
          @tcs_ratings["#{tc[:name]}"]["comments"]["#{tc[:rating]}"] << tc[:comment] if tc[:comment]
        else
          @tcs_ratings["#{tc[:name]}"]["comments"]["#{tc[:rating]}"] = [tc[:comment]] if tc[:comment]
        end

      else
        set_up_tc_record(tc)
      end
    end
    @tcs_ratings
  end

  def self.set_up_tc_record(tc)
    @tcs_ratings["#{tc[:name]}"] = {}
    @tcs_ratings["#{tc[:name]}"]["rating"] = tc[:rating]
    @tcs_ratings["#{tc[:name]}"]["cummulative_rating"] = tc[:rating]
    @tcs_ratings["#{tc[:name]}"]["count"] = 1
    @tcs_ratings["#{tc[:name]}"]["distribution"] = [0,0,0,0,0]
    @tcs_ratings["#{tc[:name]}"]["distribution"][tc[:rating]-1] += 1
    @tcs_ratings["#{tc[:name]}"]["comments"] = {}
    @tcs_ratings["#{tc[:name]}"]["comments"]["#{tc[:rating]}"] = [tc[:comment]] if tc[:comment]
  end

  def self.name_and_rating_exist(tc_data)
    !!tc_data['answers'].find { |response| response['field']['id'] == "64196466"} &&
    !!tc_data['answers'].find { |response| response['field']['id'] == "64196466"}['choices']['labels'] &&
     !!tc_data['answers'].find { |response| response['field']['id'] == "MIWlzH1BLFWb"}
  end

  def self.student_added_comment(tc_data)
    !!tc_data['answers'].find { |response| response['field']['id'] == "ummCANBFwJ5i"}
  end

  private
  def self.fetch_responses(form_id)
    responses_url = "https://api.typeform.com/forms/#{form_id}/responses?page_size=1000"
    request = Faraday.new(:url => responses_url)
    request.get do |req|
      req.headers['Authorization'] = "bearer #{@@typeform_token}"
      req.headers['Accept'] = "application/json"
    end
  end
end
