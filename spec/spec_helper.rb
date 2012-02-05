#we need the actual library file
require_relative '../lib/society_client'
 
#dependencies
require 'webmock/rspec'
require 'vcr'
 
#VCR config
VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/society_cassettes'
  c.stub_with :webmock
end