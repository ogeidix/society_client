require "httparty"
require "json"

Dir[File.dirname(__FILE__) + '/society_client/*.rb'].each do |file|
  require file
end

module SocietyClient
end



