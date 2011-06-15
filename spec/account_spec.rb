$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'hash-blue'
require 'webmock/rspec'

describe HashBlue::Account  do
  before(:all) do
    HashBlue::Client.user = "XXXXX"
  end
  context "initialize" do
    it "should be an instance of HashBlue::Account when instanciated" do
      HashBlue::Account.new.should be_an_instance_of(HashBlue::Account)
    end
  end
  
  context "find account" do
    it "should return a valid account when including valid header" do
      stub_request(:get, "https://api.hashblue.com/account").
               with(:headers => {'Accept'=>'*/*', 'Authorization'=>'OAuth XXXXX'}).
               to_return(:status => 200, :body => '{"account":{"messages":"https://api.hashblue.com/messages","msisdn":"447711223344","phone_number":"07711223344","contacts":"https://api.hashblue.com/contacts","email":"foo@hashblue.com"}}', :headers => {})      
      account = HashBlue::Account.find
      account.msisdn.should eql("447711223344")
      account.phone_number.should eql("07711223344")
      account.email.should eql("foo@hashblue.com")
    end
  end

end
