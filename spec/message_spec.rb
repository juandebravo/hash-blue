$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'hash-blue'
require 'webmock/rspec'
require 'json'

describe HashBlue::Message  do
  before(:all) do
    HashBlue::Client.user = "XXXXX"
  end
  
  context "initialize" do
    it "should be an instance of HashBlue::Message when instanciated" do
      HashBlue::Message.new.should be_an_instance_of(HashBlue::Message)
    end
  end
  
  context "find a unique message" do
    it "should return a valid message when ID is valid" do
      stub_request(:get, "https://api.hashblue.com/messages/foo").
               with(:headers => {'Accept'=>'*/*', 'Authorization'=>'OAuth XXXXX'}).
               to_return(:status => 200, :body => '{"message":{"uri":"https://api.hashblue.com/messages/foo","timestamp":"2011-05-09T21:43:52Z","sent":true,"contact":{"name":"Mike","uri":"https://api.hashblue.com/contacts/mike","messages":"https://api.hashblue.com/contacts/mike/messages","phone_number":"07711223344","msisdn":"447711223344","email":"mike@foo.com"},"content":"test","favourite":false}}', :headers => {})      

      message = HashBlue::Message.find("foo")
      message.id.should eql("foo")
      message.sent.should eql(true)
      message.contact.should be_an_instance_of(HashBlue::Contact)
      message.contact.email.should eql("mike@foo.com")
    end
  end

  context "create a new message" do
    it "should create a message successfully when phone_number and content provided" do
      stub_request(:post, "https://api.hashblue.com/messages").
               with(:body => {:message => {:phone_number => 123, :content => 'yet another test'}}, :headers => {'Accept'=>'*/*', 'Authorization'=>'OAuth XXXXX'})
               
      HashBlue::Message.create!(123, "yet another test")  
    end
  end

end
