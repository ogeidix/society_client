require_relative '../../spec_helper'
 
describe SocietyClient::Note do
  before {
    VCR.insert_cassette 'note', :record => :none,  :match_requests_on => [:body]
    @client = SocietyClient.new('wecampus','oauth2token')    
  }
  after  { VCR.eject_cassette }

  describe "#valid?" do
    it "must have an isbn" do
      expect {
        SocietyClient::Note.new(@client, :isbn=>'', :body=>'test').valid?
      }.to raise_error
    end
    
    it "must have a body" do
      expect {
        SocietyClient::Note.new(@client, :isbn=>'isbn', :body=>'').valid?
      }.to raise_error
    end
  end
 
  describe "#save!" do
    it "cannot be saved if already persisted" do
      expect{ SocietyClient::Note.new(@isbn, :isbn=>'isbn', :id=>'1').save! }.to raise_error
    end
    
    it "performe a remote save" do
      n = SocietyClient::Note.new( @client, :isbn => 'wecampus-test1', :body => 'Second note',
                                   :related_text =>'second_word',
                                   :document_location => {:firstParagraph => 2, :lastParagraph => 2} )
      n.save!.should == true
      n.should be_persisted
      n.id.should == "2829"
    end
  end

  context "instance attributes" do
    let(:note) { SocietyClient::Note.new(@client) }
  
    it "has an id" do
      note.should respond_to :id
    end
  
    it "has an isbn" do
      note.should respond_to :isbn
    end
  
    it "has a document location" do
      note.should respond_to :document_location
      note.document_location.should include :firstParagraph
      note.document_location.should include :firstWord
      note.document_location.should include :firstChar            
      note.document_location.should include :lastParagraph
      note.document_location.should include :lastWord
      note.document_location.should include :lastChar
    end
  
    it "has an username" do
      note.should respond_to :username
    end
  
    it "has a body" do
      note.should respond_to :body
    end
  
    it "has a related_text" do
      note.should respond_to :related_text
    end
  
    it "has a rating" do
      note.should respond_to :rating
    end
  
    it "has a created_at" do
      note.should respond_to :created_at
    end
  
    it "has a persisted status" do
      note.should respond_to :persisted?
    end
  end
end