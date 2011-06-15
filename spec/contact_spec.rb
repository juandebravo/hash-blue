$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'hash-blue'
require 'webmock/rspec'

describe HashBlue::Contact  do
  before(:all) do
    HashBlue::Client.user = "XXXXX"
  end
  context "initialize" do
    it "should be an instance of HashBlue::Contact when instanciated" do
      HashBlue::Contact.new.should be_an_instance_of(HashBlue::Contact)
    end
  end
  
  context "find a unique contact" do
    it "should return a valid message when ID is valid" do
      stub_request(:get, "https://api.hashblue.com/contacts/foo").
               with(:headers => {'Accept'=>'*/*', 'Authorization'=>'OAuth XXXXX'}).
               to_return(:status => 200, :body => '{"contact":{"name":"Juan","messages":"https://api.hashblue.com/contacts/dtjgcih62q5d2zl0p6k93xmw7/messages","uri":"https://api.hashblue.com/contacts/foo","msisdn":"447711223344","phone_number":"07711223344","email":"juan@foo.com"}}', :headers => {})      
      contact = HashBlue::Contact.find("foo")
      contact.id.should eql("foo")
      contact.phone_number.should eql("07711223344")
      contact.name.should eql("Juan")
      contact.email.should eql("juan@foo.com")
    end
  end
  
  context "create a new contact" do
    it "should create a contact successfully when phone_number, name and email provided" do
      stub_request(:post, "https://api.hashblue.com/contacts").
               with(:body => {:contact => {:phone_number => '123', :name => 'foo', :email => 'foo@bar.com'}}, :headers => {'Accept'=>'*/*', 'Authorization'=>'OAuth XXXXX'})
               
      HashBlue::Contact.create!("123", "foo", "foo@bar.com")  
    end
  end

end
