require 'rest_client'
require 'json'

data = RestClient.get("http://api.songkick.com/api/3.0/search/venues.json?query=the%20Fox%20theater%20oakland=&apikey=PxY0ITiYDczYNR9t", :accept => :json)
data = JSON.parse(data)

data["resultsPage"]["results"]["venue"][0]["displayName"]

data = data["resultsPage"]["results"]["venue"]

data.each { |i| spots << "#{i["displayName"]}: #{i["id"]}\n" }

venues.each { |i| puts "#{i["displayName"]}: #{i["id"]}\n" }

data = RestClient.get("http://api.songkick.com/api/3.0/venues/#{incoming_sms}/calendar.json?apikey=PxY0ITiYDczYNR9t", :accept => :json)

data = RestClient.get("http://api.songkick.com/api/3.0/venues/953251/calendar.json?apikey=PxY0ITiYDczYNR9t", :accept => :json)
data = JSON.parse(data)


data = data["resultsPage"]["results"]["even"]


>> data["resultsPage"]["results"]["event"][0]["displayName"] #=> "The Naked and Famous with NO at Fox Theater (October 25, 2013)"
>> data["resultsPage"]["results"]["event"][0]["start"]["time"] #=> "20:00:00"