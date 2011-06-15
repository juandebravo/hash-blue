O2 Labs has exposed the power of \#blue to developers via a simple REST & JSON based API, combined with oAuth2 to developers who can create  new ways for users to manage their texts and add combine the ubiquity of SMS with their applications, users simply grant an application access to their messages stream or just certain messages.

\#blue is not a service designed for users to text into applications rather it is aimed at enriching the users existing text experience by building on top of their day to day text use.

This gem provides a smooth access to \#blue API.

# How to install

    gem install hash-blue

# Getting started

There're three main entities in \#blue:

*   message: models a SMS sent/received by the user
*   contact: friend's list including phone number, name and email address.
*   account: describes the user account

\#blue client design is based on ActiveRecord model.

## Retrieve a valid user token using OAuth 2.0

\#blue API is based on oAuth secure mechanism so before using the API the user must grant permissions to your application. Follow the instructions on [the HashBlue documentation](https://api.hashblue.com/doc/Authentication)

You can either use the Rails Engine or create your own logic.

### Use the embedded Rails Engine

* Insert in your rails application Gemfile the dependency hash-blue
    gem 'hash-blue'

* Two new endpoints are created (check running ''bundle install'' and ''rake routes''):
    
    \# this method redirects to hashblue web page to start the oAuth process
    
    /hashblue/index 
    \# this method gets the Oauth response, asks for a valid access token and sends the data
    
    /hashblue/code

* Configure in an application initializer your specific data (i.e. config/initializer/hashblue.rb)

    Rails.application.config.hashblue.client_id = <app_client_id>
    Rails.application.config.hashblue.client_secret = <app_client_secret>
    \# Internal redirection to handle the HashBlue response. You'll receive a GET request to that action
    \# after OAuth mechanism with user access token info: :access_token, :expires_in, :refresh_token 
	Rails.application.config.hashblue.forward_action = <controller#action>
	
### Create the logic to handle the OAuth mechanism

#### First step. Redirect user to HashBlue authorization page

    redirect_to "https://hashblue.com/oauth/authorize?client_id=<app_client_id>&redirect_uri=<your_callback_url>"

#### Second step. Get access token

    uri = URI.parse("https://hashblue.com")
    rest = Net::HTTP.new(uri.host, uri.port)
    rest.use_ssl = true
    code = <code_from_first_step>

    params = {
	    :client_id => <app_client_id>,
	    :client_secret => <app_client_secret>,
	    :grant_type => <authorization_code>,
	    :code => code,
	    :redirect_uri => <your_callback_url>
    }
    query = params.collect { |k, v| "#{k}=#{v.to_s}" }.join("&")) 
    access_token = rest.post( "/oauth/access_token?#{query}", nil)

## Configure the client with a valid access token

    HashBlue::Client.user = <valid_access_token>

## Work with messages

### Retrieve all messages

    messages = HashBlue::Message.find(:all)
	messages = HashBlue::Message.find
	
### Retrieve a specific message

	message = HashBlue::Message.find(<valid_message_id>)
	
### Retrieve the first message

   message = HashBlue::Message.find(:first)

### Retrieve messages since January 14th, 2011

    messages = HashBlue::Message.find({:since => "2011-01-14T14:30Z")

### Retrieve messages from 20 to 25

    messages = HashBlue::Message.find({:first => 20, :count => 5)

### Retrieve a contact messages

	messages = HashBlue::Message.find({:contact => <valid_contact_id>})

### Retrieve favourite messages

	messages = HashBlue::Message.favourites

### Mark a message as favourite

	message = HashBlue::Message.find(<valid_message_id>)
	message.favourite!

### Unmark a message as favourite

	message = HashBlue::Message.find(<valid_message_id>)
	message.unfavourite!

### Create a message

	HashBlue::Message.create!(<phone_number>, <content>)

## Work with contacts

### Retrieve all contacts

	contacts = HashBlue::Contact.find(:all)

### Retrieve a specific contact

	contact = HashBlue::Contact.find(<contact_id>)

### Crete a contact

	HashBlue::Contact.create!(<phone_number>, <name>, <email>)
	
## Work with account

### Retrieve user account

	HashBlue::Account.find

# Version 0.2 features

- Rails Engine: includes OAuth 2.0 support
- Message filtering: enables :first, {:since => date}, {:first => index, :count => number}

# TODO
- Enhance pagination mechanism for messages and contacts
- Search by time: test the date format. Support both a string and a Date/Time with valid ISO 8601 format
- Check q parameter in searches
- Use ActiveSupport instead of json_pure

# Author

Juan de Bravo

juandebravo at gmail dot com

Ruby sensei @ [The Lab](http://thelab.o2.com)


