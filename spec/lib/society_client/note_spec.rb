# require_relative '../../spec_helper'
#  
# describe SocietyClient::Note do
#   before { VCR.insert_cassette 'note', :record => :once,  :match_requests_on => [:body] }
#   after  { VCR.eject_cassette }
#  
#   context "default httparty attributes" do
#     it "must include httparty methods" do
#       SocietyClient::Note.should include HTTParty
#     end
#     it "must have the base url set to the Society API endpoint" do
#       SocietyClient::Note.base_uri.should == 'http://beta.teamlife.it/society/services/json'
#     end
#   end
# 
#   describe "#valid?" do
#     it "must have an isbn" do
#       expect{ Note.new('').valid? }.to raise_error
#     end
#     
#     it "must have a body" do
#       expect{ Note.new('isbn', :body=>'').valid? }.to raise_error
#     end
#     
#     it "must have an author" do
#       expect{ Note.new('isbn', :author=>'').valid? }.to raise_error
#     end
#   end
#  
#   describe "#create" do
#     it "cannot be saved if already persisted" do
#       expect{ Note.new('isbn', :id=>'1').save! }.to raise_error
#     end
#     
#     it "performe a remote save" do
#       n = SocietyClient::Note.new( :isbn => 'wecampus-test1', :body => 'Second note',
#                                    :related_text =>'second_word', :author => 'apigato',
#                                    :document_location => {:firstParagraph => 2, :lastParagraph => 2} )
#       n.save!.should == true
#       n.should be_persisted
#       n.id.should == "1490"
#     end
#   end
#  
#   describe "::find_all" do
#     it "must permit to retrieve all notes for a specific isbn" do
#       notes = SocietyClient::Note.find_all(:document => 'wecampus-test1')
#       notes.should be_instance_of Array
#       notes.size.should == 2
#       notes.each {|n| n.isbn.should == 'wecampus-test1'}
#       notes[0].author.should == 'dgiorgini'
#       notes[0].body.should == 'First note'
#       notes[1].author.should == 'apigato'
#       notes[1].body.should == 'Second note'
#     end
#     
#     it "must permit to filter by author" do
#       notes = SocietyClient::Note.find_all(:document => 'wecampus-test1', :author => 'apigato')
#       notes.should be_instance_of Array
#       notes.size.should == 1
#       notes[0].author.should == 'apigato'
#       notes[0].body.should == 'Second note'      
#     end
#     
#     it "must permit to filter by first paragraph" do
#       notes = SocietyClient::Note.find_all(:document => 'wecampus-test1', :firstParagraph => '2')
#       notes.should be_instance_of Array
#       notes.size.should == 1
#       notes[0].author.should == 'apigato'
#       notes[0].body.should == 'Second note'
#     end
#     
#     it "must permit to filter by last paragraph" do
#       notes = SocietyClient::Note.find_all(:document => 'wecampus-test1', :lastParagraph => '2')
#       notes.should be_instance_of Array
#       notes.size.should == 2
#       notes[0].author.should == 'dgiorgini'
#       notes[0].body.should == 'First note'
#       notes[1].author.should == 'apigato'
#       notes[1].body.should == 'Second note'
#     end
#     
#     it "must permit to filter by paragraph range" do
#       notes = SocietyClient::Note.find_all(:document => 'wecampus-test1', :firstParagraph => '1', :lastParagraph => '1')
#       notes.should be_instance_of Array
#       notes.size.should == 0
#     end
#   
#     it "must permit to retrieve all notes for a specific user" do
#       notes = SocietyClient::Note.find_all(:author=>'apigato')
#       notes.should be_instance_of Array
#       notes.each {|n| n.author.should == 'apigato'}
#     end
#     
#   end
# 
#   context "instance attributes" do
#     let(:note) { SocietyClient::Note.new }
#   
#     it "has an id" do
#       note.should respond_to :id
#     end
#   
#     it "has an isbn" do
#       note.should respond_to :isbn
#     end
#   
#     it "has a document location" do
#       note.should respond_to :document_location
#       note.document_location.should include :firstParagraph
#       note.document_location.should include :firstWord
#       note.document_location.should include :firstChar            
#       note.document_location.should include :lastParagraph
#       note.document_location.should include :lastWord
#       note.document_location.should include :lastChar
#     end
#   
#     it "has an author" do
#       note.should respond_to :author
#     end
#   
#     it "has a body" do
#       note.should respond_to :body
#     end
#   
#     it "has a related_text" do
#       note.should respond_to :related_text
#     end
#   
#     it "has a rating" do
#       note.should respond_to :rating
#     end
#   
#     it "has a created_at" do
#       note.should respond_to :created_at
#     end
#   
#     it "has a persisted status" do
#       note.should respond_to :persisted?
#     end
#   end
# end