require "httparty"
require "json"

class SocietyClient
  include HTTParty
  base_uri 'http://society-school.teamlife.it/services/json'

  attr_reader :username

  def initialize(username, oauth2_token)
    @username     = username
    @oauth2_token = oauth2_token
    @session_id   = send_query('services_oauth.login')['sessid']
  end
  
  def notes
    @notes ||= SocietyClient::Notes.new(self)
  end
  
  def send_query(method, content = nil)
    body =         "method=#{method}"
    body = body + "&content=#{content.to_json}" if content
    body = body + "&sessid=#{@session_id}"      if @session_id
    request_headers = {'Authorization' => "OAuth #{@oauth2_token}"}
    response = self.class.post('', {:body => body, :headers => request_headers})
    raise "Unauthorized: wrong oauth2 token" if response.code == 401
    parsed_response = JSON.parse(response.parsed_response)
    raise "Remote error: #{parsed_response['#data']}" if parsed_response['#error']
    return parsed_response['#data']
  end
end

Dir[File.dirname(__FILE__) + '/society_client/*.rb'].each do |file|
  require file
end