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
    @tcs_data = []
    ratings_data.each do |tc_data|
      if name_and_rating_exist(tc_data)
        tc = {}
        tc[:name] = tc_data['answers'].select { |response| response['field']['id'] == "UITJ1QSVLpHp"}[0]['choice']['label']
        tc[:rating] = tc_data['answers'].select { |response| response['field']['id'] == "ySW1ykZbvteg"}[0]['number']
        if student_added_comment(tc_data)
          tc[:comment] = tc_data["answers"].find {|response| response['field']['id'] == "PIQz3JHZOBNu"}["text"]
          tc[:date] = DateTime.strptime(tc_data["submitted_at"]).strftime('%D')
        end
        @tcs_data << tc
      end
    end
    aggregate(@tcs_data)
  end

  def self.aggregate(tcs_data)
    @tcs_ratings = {}
    tcs_data.each do |tc|
      if @tcs_ratings.keys.include?(tc[:name])
        @tcs_ratings["#{tc[:name]}"]["distribution"][tc[:rating]-1] += 1
        add_comments(tc)
      else
        set_up_tc_record(tc)
      end
    end
    convert_dist_to_percents
    slugify_names
    @tcs_ratings
  end

  def self.convert_dist_to_percents
    tcs = @tcs_ratings.map{|tc| tc.first}
    tcs.each do |tc|
      array = @tcs_ratings[tc]["distribution"]
      total = array.reduce(0){|result, current| result += current}
      @tcs_ratings[tc]["percents"] = array.collect{|num| get_percentage(num, total)}
    end
  end

  def self.get_percentage(num, total)
    result = num.to_f * (100.to_f/total.to_f)
    "#{result.round}%"
  end

  def self.convert_name_to_slug(name)
    slug_name = name.gsub(/[^a-zA-Z]/,'-').downcase
  end

  def self.slugify_names
    tcs = @tcs_ratings.map{|tc| tc.first}
    tcs.each do |tc|
      @tcs_ratings[tc]["slug"] = convert_name_to_slug(tc)
    end
  end

  def self.set_up_tc_record(tc)
    @tcs_ratings["#{tc[:name]}"] = {}
    @tcs_ratings["#{tc[:name]}"]["distribution"] = [0,0,0,0,0]
    @tcs_ratings["#{tc[:name]}"]["distribution"][tc[:rating]-1] += 1
    @tcs_ratings["#{tc[:name]}"]["comments"] = {}
    add_comments(tc)
  end

  def self.add_comments(tc)
    if @tcs_ratings["#{tc[:name]}"]["comments"].keys.include?(tc[:rating].to_s)
      @tcs_ratings["#{tc[:name]}"]["comments"]["#{tc[:rating]}"] << {comment: tc[:comment], date: tc[:date]} if tc[:comment]
    else
      @tcs_ratings["#{tc[:name]}"]["comments"]["#{tc[:rating]}"] = [{comment: tc[:comment], date: tc[:date]}] if tc[:comment]
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
