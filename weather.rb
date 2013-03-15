require 'open-uri'
require 'json'

class WeatherReporter
	def get_conditions
		c = nil
		url = ('http://api.wunderground.com/api/bc06bcd794ade842/geolookup/conditions/q/Canada/Toronto.json')
		open url do |f|
			json_string = f.read
			current_conditions = JSON.parse(json_string)
			@location = current_conditions['location']['city']
			temp_f = current_conditions['current_observation']['temperature_string']
			wind_f = current_conditions['current_observation']['wind_string']
			feels_f = current_conditions['current_observation']['feelslike_string']
			weather_f = current_conditions['current_observation']['weather']
			c = "It is currently #{temp_f} in #{@location}. #{weather_f} with wind #{wind_f}. It feels like #{feels_f}."
		end
		return c
	end

	def get_forecast_today
		f = nil
		url = ('http://api.wunderground.com/api/bc06bcd794ade842/forecast/q/Canada/Toronto.json')
		open url do |f|
			json_string = f.read
			forecast_today = JSON.parse(json_string)
			day = forecast_today['forecast']['txt_forecast']['forecastday'][0]['title']
			day_text = forecast_today['forecast']['txt_forecast']['forecastday'][0]['fcttext']
			night = forecast_today['forecast']['txt_forecast']['forecastday'][0]['title']
			night_text = forecast_today['forecast']['txt_forecast']['forecastday'][0]['fcttext']
			f = "The forecast for #{@location} on #{day} is #{day_text} #{night_day} will be #{night_text}"
		end
	end
end

#include timestamp. Check the weather every half hour.
#check the weather everytime the weather was more than 30 minutes ago, time.now + 30.minutes
#throttling our weather call. 