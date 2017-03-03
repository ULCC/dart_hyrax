# Orcid Helper
module OrcidHelper
  def orcid_response(id)
    return unless valid_orcid?(id)
    response = connection('https://pub.orcid.org').get do |req|
      req.url '/v1.2/' + trim_orcid_url(id)
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = 'Bearer ' + orcid_token
    end
    JSON.parse(response.body)['orcid-profile']
  rescue
    Rails.logger.error($ERROR_INFO.to_s)
  end

  def valid_orcid?(orcid)
    orcid = trim_orcid_url(orcid)
    return unless valid_orcid_structure?(orcid)
    return unless valid_orcid_length?(orcid)
    return unless valid_orcid_content?(orcid)
    valid_orcid_checksum?('orcid')
  end

  def trim_orcid_url(orcid)
    orcid.strip!
    orcids = orcid.split('/')
    orcids[orcids.length - 1]
  end

  private

  # ORCID must contain four sets of characters separated by '-'
  def valid_orcid_structure?(orcid)
    orcid.count('-') == 3 ? true : false
  end

  # ORCID must contain 16 characters (exluding dashes)
  def valid_orcid_length?(orcid)
    orcid.delete('-').length == 16 ? true : false
  end

  # ORCID must comprise 15 digits, ending with a digit or 'X'
  def valid_orcid_content?(orcid)
    (/[0-9]{15}/ =~ orcid.delete('-')[0..-2]) &&
      /[0-9X]/.match(orcid.delete('-')[-1..-1])
  end

  # ORCID must verify against the ORCID checksum algorithm
  # https://docs.google.com/spreadsheets/d/17KYZ-QMixxE55qxws2KovHy7LvC_ErfUKb2HzGiu3NQ/edit#gid=0
  def valid_orcid_checksum?(orcid)
    subcalculation = 0
    orcid.delete('-').split('').each_with_index do |digit, index|
      if index < 15
        subcalculation = (digit.to_i + subcalculation) * 2
      else
        result = 12 - (subcalculation.to_i % 11)
        result = 'X' if result == 10
        digit == result.to_s ? true : false
      end
    end
  end

  def connection(url)
    conn = Faraday.new(url: url) do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn
  end

  def orcid_token
    return ENV['ORCID_TOKEN'] unless ENV['ORCID_TOKEN'].nil?
    access_token = retrieve_orcid_token
    env = Rails.root + '.env'
    if access_token
      File.open(env, 'a') { |f| f.puts "\nORCID_TOKEN=#{access_token}" }
    end
    ENV['ORCID_TOKEN']
  end

  def retrieve_orcid_token
    conn = connection('https://pub.orcid.org')
    response = conn.post '/oauth/token',
                         client_id: ENV['ORCID_CLIENT_ID'],
                         client_secret: ENV['ORCID_CLIENT_SECRET'],
                         scope: '/read-public',
                         grant_type: 'client_credentials'
    JSON.parse(response.body)['access_token']
  rescue
    Rails.logger.error($ERROR_INFO)
  end
end
