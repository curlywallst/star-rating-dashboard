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
      if name_and_rating_exist(tc_data)
        tc = {}
        tc_data['answers'].select { |response| response['field']['id'] == "64196466"}[0]['choices']['labels'].each do |tc_name|
          tc = {}
          tc[:name] = tc_name
          tc[:rating] = tc_data['answers'].select { |response| response['field']['id'] == "MIWlzH1BLFWb"}[0]['number']
          if student_added_comment(tc_data)
            tc[:comment] = tc_data["answers"].find {|response| response['field']['id'] == "ummCANBFwJ5i"}["text"]
            tc[:date] = DateTime.strptime(tc_data["submitted_at"]).strftime('%D')
          end
          @tcs_data << tc
        end
      end
    end
    aggregate(@tcs_data)
  end

  def self.aggregate(array)
    @tcs_ratings = {}
    array.each do |tc|
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
