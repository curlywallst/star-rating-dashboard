require 'json'

class AaqStarRatingAdapter
  TYPEFORM_TOKEN_KEY = "TYPEFORM_TOKEN"

  def self.ratings  #(form_id)
    form_id = 'hxUWlz'
    @@typeform_token = ENV[TYPEFORM_TOKEN_KEY]
    JSON.parse(fetch_responses(form_id).body)
  end

  def self.get_ratings
    ratings_data = AaqStarRatingAdapter.ratings['items']
    # binding.pry
    # @tcs_data = []
    ratings_data.each do |tc_data|
      if name_and_rating_exist(tc_data)
        tc_data['answers'].select { |response| response['field']['id'] == "wvmlklnB91sp"}[0]['choices']['labels'].each do |tc_name|
          tc = {}
          tc[:name] = tc_name
          tc[:rating] = tc_data['answers'].select { |response| response['field']['id'] == "UFXe8EZFkaWb"}[0]['number']
          tc[:landing_id] = tc_data["landing_id"]
          tc[:date] = tc_data["submitted_at"]
          if student_added_comment(tc_data)
            tc[:comment] = tc_data["answers"].find {|response| response['field']['id'] == "By8xptHcCiCC"}["text"]
          end
          # binding.pry
          technical_coach = TechnicalCoach.find_by(name: tc[:name])
          if !technical_coach
            technical_coach = TechnicalCoach.create({name: tc[:name], ratings: []})
          end
          rating_data = Rating.find_by(landing_id: tc[:landing_id])
          if !rating_data
            rating_data = Rating.create({landing_id: tc[:landing_id], stars: tc[:rating], comment: tc[:comment], rating_type: "AAQ", date: tc[:date]})
          end
          technical_coach.ratings << rating_data unless technical_coach.ratings.include?(rating_data)
        end
      end
    end
  end

  def self.name_and_rating_exist(tc_data)
    !!tc_data['answers'].find { |response| response['field']['id'] == "wvmlklnB91sp"} &&
    !!tc_data['answers'].find { |response| response['field']['id'] == "wvmlklnB91sp"}['choices']['labels'] &&
     !!tc_data['answers'].find { |response| response['field']['id'] == "UFXe8EZFkaWb"}
  end

  def self.student_added_comment(tc_data)
    comment = tc_data['answers'].find { |response| response['field']['id'] == "By8xptHcCiCC"}
    !!comment
  end

  private
  def self.fetch_responses(form_id)
    responses_url = "https://api.typeform.com/forms/#{form_id}/responses"
    request = Faraday.new(:url => responses_url)
    request.get do |req|
      req.params['page_size'] = 1000
      req.params['since'] = (DateTime.now-30).to_i
      req.headers['Authorization'] = "bearer #{@@typeform_token}"
      req.headers['Accept'] = "application/json"
    end
  end
end
