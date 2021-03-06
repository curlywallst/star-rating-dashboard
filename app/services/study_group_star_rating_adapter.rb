require 'json'

class StudyGroupStarRatingAdapter
  TYPEFORM_TOKEN_KEY = "TYPEFORM_TOKEN"

  def self.ratings  #(form_id)
    form_id = 'jMLdwE'
    @@typeform_token = ENV[TYPEFORM_TOKEN_KEY]
    JSON.parse(fetch_responses(form_id).body)
  end

  def self.get_ratings
    ratings_data = StudyGroupStarRatingAdapter.ratings['items']
    ratings_data.each do |tc_data|
      if name_and_rating_exist(tc_data)
        tc = {}
        tc[:name] = tc_data['answers'].select { |response| response['field']['id'] == "UITJ1QSVLpHp"}[0]['choice']['label']
        tc[:rating] = tc_data['answers'].select { |response| response['field']['id'] == "ySW1ykZbvteg"}[0]['number']
        tc[:landing_id] = tc_data["landing_id"]
        tc[:date] = tc_data["submitted_at"]
        if student_added_comment(tc_data)
          tc[:comment] = tc_data["answers"].find {|response| response['field']['id'] == "PIQz3JHZOBNu"}["text"]
        end
        technical_coach = TechnicalCoach.find_by(name: tc[:name])
        if !technical_coach
          technical_coach = TechnicalCoach.create({name: tc[:name], ratings: []})
        end
        rating_data = Rating.find_by(landing_id: tc[:landing_id])
        if !rating_data
          rating_data = Rating.create({landing_id: tc[:landing_id], stars: tc[:rating], comment: tc[:comment], rating_type: "SG", date: tc[:date]})
        end
        technical_coach.ratings << rating_data unless technical_coach.ratings.include?(rating_data)
      end
    end
  end

  def self.name_and_rating_exist(tc_data)
    !!tc_data['answers'].find { |response| response['field']['id'] == "UITJ1QSVLpHp"} &&
    !!tc_data['answers'].find { |response| response['field']['id'] == "UITJ1QSVLpHp"}['choice']['label'] &&
     !!tc_data['answers'].find { |response| response['field']['id'] == "ySW1ykZbvteg"}
  end

  def self.student_added_comment(tc_data)
    !!tc_data['answers'].find { |response| response['field']['id'] == "PIQz3JHZOBNu"}
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
