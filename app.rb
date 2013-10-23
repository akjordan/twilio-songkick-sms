require 'sinatra'
require 'uri'

# setup RestClient caching backed by Memcachier
RestClient.enable Rack::Cache,
  :verbose      => true,
  :metastore   => Dalli::Client.new,
  :entitystore => Dalli::Client.new

# this route handles all POST requests from Twilio
post "/" do

# take the body of the SMS and remove any spaces and make all lower case
incoming_sms = params["Body"].downcase

#If they text help return a help message
if incoming_sms.include?("help")
	# query Splitcast API and store JSON of spots
	response = Twilio::TwiML::Response.new  { |r| r.Sms "Type in venue name to get an ID, once you get an ID type in ID and the word tonight to get what's playing!" }
# if they send in just numbers search for a venue calendar
elsif incoming_sms.match('^[0-9]+$')
	response_string = ""

	# query songkick API and store JSON of events for the given venue ID
	data = RestClient.get("http://api.songkick.com/api/3.0/venues/#{incoming_sms}/calendar.json?apikey=PxY0ITiYDczYNR9t", :accept => :json)
	data = JSON.parse(data)
	data = data["resultsPage"]["results"]["event"]
	data.each { |i| response_string << "#{i["displayName"]}: #{i["start"]["time"]}\n" }

	# build Twilio response
	response = Twilio::TwiML::Response.new  { |r| r.Sms "#{response_string}" }
#otherwise interperate this search for a venue ID
else
	response_string = ""

	incoming_sms_escaped = URI.escape(incoming_sms)
	data = RestClient.get("http://api.songkick.com/api/3.0/search/venues.json?query=#{incoming_sms_escaped}&apikey=PxY0ITiYDczYNR9t", :accept => :json)
	data = JSON.parse(data)
	data = data["resultsPage"]["results"]["venue"]

	data.each { |i| response_string << "#{i["displayName"]}: #{i["id"]}\n" }

	response = Twilio::TwiML::Response.new  { |r| r.Sms "#{response_string}" }
end
# return valid TwiML back to Twilio
response.text
end