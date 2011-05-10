O2 Labs has exposed the power of #blue to developers via a simple REST & JSON based API, combined with oAuth2 to developers who can create  new ways for users to manage their texts and add combine the ubiquity of SMS with their applications, users simply grant an application access to their messages stream or just certain messages.

_#_blue is not a service designed for users to text into applications rather it is aimed at enriching the users existing text experience by building on top of their day to day text use.

This gem provides a smooth access to _#_blue API.

# How to install

    gem install hash-blue

# Getting started

There're three main entities in _#_blue:

*   message: models a SMS sent/received by the user
*   contact: friend's list including phone number, name and email address.
*   account: describes the user account

_#_blue client design is based on ActiveRecord model.

## Retrieve a valid user token

_#_blue API is based on oAuth secure mechanism so before using the API the user must grant permissions to your application. Follow the instructions on [the HashBlue documentation](https://api.hashblue.com/doc/Authentication)

### First step. Redirect user to HashBlue authorization page

    redirect_to "https://hashblue.com/oauth/authorize?client_id=<app_client_id>&redirect_uri=<your_callback_url>"

### Second step. Get access token

    uri = URI.parse("https://hashblue.com")
    rest = Net::HTTP.new(uri.host, uri.port)
    rest.use_ssl = true
    code = <code_from_first_step>

    query = "client_id=<app_client_id>&client_secret=<app_client_secret>&grant_type=authorization_code&code=#{code}&redirect_uri=<your_callback_url>"
    access_token = rest.post( "/oauth/access_token?#{query}", nil)

## Configure the client with a valid access token

    HashBlue::Client.user = <valid_access_token>

## Work with messages

### Retrieve all messages

    messages = HashBlue::Message.find(:all)
	messages = HashBlue::Message.find
	
### Retrieve a specific message

	message = HashBlue::Message.find(<valid_message_id>)

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

# Author

Juan de Bravo

juandebravo at gmail dot com

Ruby sensei @ [The Lab](http://thelab.o2.com)


