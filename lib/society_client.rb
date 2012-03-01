require "httparty"
require "json"

class SocietyClient
  include HTTParty
  base_uri 'http://society-school.teamlife.it/services/json'

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
    request_headers['Cookie'] = @cookie if @cookie
    response = self.class.post('', {:body => body, :headers => request_headers})
    raise "Unauthorized: wrong oauth2 token" if response.code == 401
    @cookie = retrieve_cookie(response.headers['set-cookie']) if response.headers['set-cookie']
    parsed_response = JSON.parse(response.parsed_response)
    raise "Remote error: #{parsed_response['#data']}" if parsed_response['#error']
    return parsed_response['#data']
  end
  
  protected
    def retrieve_cookie(h)
      data = h.split(' ').reverse!
      data.each { |v|
        return v[0..-2] if v.size > 36
      }
    end
end

Dir[File.dirname(__FILE__) + '/society_client/*.rb'].each do |file|
  require file
end