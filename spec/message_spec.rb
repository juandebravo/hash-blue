$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'hash-blue'
require 'webmock/rspec'

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
  
  context "find messages" do
    it "should return a list of messages" do
      stub_request(:get, "https://api.hashblue.com/messages").
               with(:headers => {'Accept'=>'*/*', 'Authorization'=>'OAuth XXXXX'}).
               to_return(:status => 200, :body => '{"messages":[{"uri":"https://api.hashblue.com/messages/foo","timestamp":"2011-05-09T21:43:52Z","sent":true,"contact":{"name":"Mike","uri":"https://api.hashblue.com/contacts/mike","messages":"https://api.hashblue.com/contacts/mike/messages","phone_number":"07711223344","msisdn":"447711223344","email":"mike@foo.com"},"content":"test","favourite":false}, {"uri":"https://api.hashblue.com/messages/bar","timestamp":"2011-05-09T21:43:52Z","sent":true,"contact":{"name":"Mike","uri":"https://api.hashblue.com/contacts/mike","messages":"https://api.hashblue.com/contacts/mike/messages","phone_number":"07711223344","msisdn":"447711223344","email":"mike@foo.com"},"content":"this is another test","favourite":true}]}', :headers => {})      

      message = HashBlue::Message.find()
      message.should be_an_instance_of(Array)
      message.should respond_to(:length)
      message.length.should eql(2)
      message[0].should be_an_instance_of(HashBlue::Message)
      message[1].should be_an_instance_of(HashBlue::Message)
    end

    it "should return the first message when paramter is :first" do
      stub_request(:get, "https://api.hashblue.com/messages?per_page=1").
               with(:headers => {'Accept'=>'*/*', 'Authorization'=>'OAuth XXXXX'}).
               to_return(:status => 200, :body => '{"messages":[{"uri":"https://api.hashblue.com/messages/foo","timestamp":"2011-05-09T21:43:52Z","sent":true,"contact":{"name":"Mike","uri":"https://api.hashblue.com/contacts/mike","messages":"https://api.hashblue.com/contacts/mike/messages","phone_number":"07711223344","msisdn":"447711223344","email":"mike@foo.com"},"content":"test","favourite":false}]}', :headers => {})      

      message = HashBlue::Message.find(:first)
      message.should be_an_instance_of(Array)
      message.should respond_to(:length)
      message.length.should eql(1)
      message[0].should be_an_instance_of(HashBlue::Message)
    end
    
    it "should request messages since a specific date when parameter :since defined" do
      date = "2011-01-14T14:30Z"
      stub_request(:get, "https://api.hashblue.com/messages?since=#{date}").
               with(:headers => {'Accept'=>'*/*', 'Authorization'=>'OAuth XXXXX'}).
               to_return(:status => 200, :body => '{"messages":[{"uri":"https://api.hashblue.com/messages/foo","timestamp":"2011-05-09T21:43:52Z","sent":true,"contact":{"name":"Mike","uri":"https://api.hashblue.com/contacts/mike","messages":"https://api.hashblue.com/contacts/mike/messages","phone_number":"07711223344","msisdn":"447711223344","email":"mike@foo.com"},"content":"test","favourite":false}]}', :headers => {})      

      message = HashBlue::Message.find({:since => date})
      message.should be_an_instance_of(Array)
      message.should respond_to(:length)
      message.length.should eql(1)
      message[0].should be_an_instance_of(HashBlue::Message)
    end

    it "should request messages since a specific index when parameter {:first} defined" do
      first = 15
      stub_request(:get, "https://api.hashblue.com/messages?page=2&per_page=#{first}").
               with(:headers => {'Accept'=>'*/*', 'Authorization'=>'OAuth XXXXX'}).
               to_return(:status => 200, :body => '{"messages":[{"uri":"https://api.hashblue.com/messages/foo","timestamp":"2011-05-09T21:43:52Z","sent":true,"contact":{"name":"Mike","uri":"https://api.hashblue.com/contacts/mike","messages":"https://api.hashblue.com/contacts/mike/messages","phone_number":"07711223344","msisdn":"447711223344","email":"mike@foo.com"},"content":"test","favourite":false}]}', :headers => {})      

      message = HashBlue::Message.find({:first => first})
      message.should be_an_instance_of(Array)
      message.should respond_to(:length)
      message.length.should eql(1)
      message[0].should be_an_instance_of(HashBlue::Message)
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
