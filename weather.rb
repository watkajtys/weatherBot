require 'open-uri'
require 'json'

def weather
	open('http://api.wunderground.com/api/bc06bcd794ade842/geolookup/conditions/q/Canada/Toronto.json') do |f|
	  json_string = f.read
	  parsed_json = JSON.parse(json_string)
	  location = parsed_json['location']['city']
	  temp_f = parsed_json['current_observation']['temperature_string']
	  wind_f = parsed_json['current_observation']['wind_string']
	  feels_f = parsed_json['current_observation']['feelslike_string']
	  weather_f = parsed_json['current_observation']['temperature_string']
	  print "It is currently #{temp_f} in #{location}. It's #{weather_f} with wind #{wind_f}."
	  print "It feels like #{feels_f}"
	end
end