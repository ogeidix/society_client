require_relative '../spec_helper'
 
describe SocietyClient do
  before { VCR.insert_cassette 'client', :record => :once,  :match_requests_on => [:body] }
  after  { VCR.eject_cassette }
 
  context "default httparty attributes" do
    it "must include httparty methods" do
      SocietyClient.should include HTTParty
    end
    it "must have the base url set to the Society API endpoint" do
      SocietyClient.base_uri.should_not be_nil
    end
  end
 
  describe "#initialize" do    
    it "should raise error if auth data are wrong" do
      expect{ SocietyClient.new('wecampus', 'wrong_oauth2_token') }.to raise_error 'Unauthorized: wrong oauth2 token'
    end
  end
end