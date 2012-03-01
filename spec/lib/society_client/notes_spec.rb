require_relative '../../spec_helper'
 
describe SocietyClient::Notes do
  before(:all) {
    VCR.insert_cassette 'notes', :record => :once,  :match_requests_on => [:body]
    @client = SocietyClient.new('wecampus','b2df4998b00a490eb1206bbe8f8d225e')
  }
  after(:all) { VCR.eject_cassette }
 
  describe "::find_all_by_document" do
    it "should permit to retrieve all notes for a specific isbn" do
      p @client
      notes = @client.notes.find_all_by_document('wecampus-test1')
      notes.should be_instance_of Array
      notes.size.should == 2
      notes.each {|n| n.isbn.should == 'wecampus-test1'}
      notes[0].username.should == 'dgiorgini'
      notes[0].body.should == 'First note'
      notes[1].username.should == 'apigato'
      notes[1].body.should == 'Second note'
    end
    
    it "must permit to filter by username" do
      p @client      
      notes = @client.notes.find_all_by_document('wecampus-test1', :username => 'apigato')
      notes.size.should == 1
      notes[0].username.should == 'apigato'
      notes[0].body.should == 'Second note'      
    end
    
    it "must permit to filter by first paragraph" do
      p @client      
      notes = @client.notes.find_all_by_document('wecampus-test1', :firstParagraph => '2')
      notes.size.should == 1
      notes[0].username.should == 'apigato'
      notes[0].body.should == 'Second note'
    end
    
    it "must permit to filter by last paragraph" do
      notes = @client.notes.find_all_by_document('wecampus-test1', :lastParagraph => '2')
      notes.size.should == 2
      notes[0].username.should == 'dgiorgini'
      notes[0].body.should == 'First note'
      notes[1].username.should == 'apigato'
      notes[1].body.should == 'Second note'
    end
    
    it "must permit to filter by paragraph range" do
      notes = @client.notes.find_all_by_document('wecampus-test1', :firstParagraph => '1', :lastParagraph => '1')
      notes.size.should == 0
    end 
  end
end