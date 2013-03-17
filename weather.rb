require 'open-uri'
require 'json'

class WeatherReporter
	attr_reader :location

	def initialize
		@location = 'Toronto'
	end
	
	def get_conditions
		c = nil
		url = ('http://api.wunderground.com/api/bc06bcd794ade842/geolookup/conditions/q/Canada/Toronto.json')
		# conditions_time = Time.now
		# if (conditions_time + 30*60) < conditions_time
			open url do |f|
				json_string = f.read
				current_conditions = JSON.parse(json_string)
				location = current_conditions['location']['city']
				temp_f = current_conditions['current_observation']['temperature_string']
				wind_f = current_conditions['current_observation']['wind_string']
				feels_f = current_conditions['current_observation']['feelslike_string']
				weather_f = current_conditions['current_observation']['weather']
				c = "It is currently #{temp_f} in #{location}. #{weather_f} with wind #{wind_f}. It feels like #{feels_f}."
			end
		# end
	end

	def get_forecast_today
		f = nil
		url = ('http://api.wunderground.com/api/bc06bcd794ade842/forecast/q/Canada/Toronto.json')
		# forecast_time = Time.now
		# if (forecast_time + 30*60) < forecast_time
			open url do |f|
				json_string = f.read
				forecast_today = JSON.parse(json_string)
				day = forecast_today['forecast']['txt_forecast']['forecastday'][0]['title']
				day_text = forecast_today['forecast']['txt_forecast']['forecastday'][0]['fcttext']
				night = forecast_today['forecast']['txt_forecast']['forecastday'][1]['title']
				night_text = forecast_today['forecast']['txt_forecast']['forecastday'][1]['fcttext']
				f = "The forecast for #{location} on #{day} is #{day_text} #{night} will be #{night_text}"
			end
		# end
	end

	def get_temperatures_week
		fw = nil
		url = ('http://api.wunderground.com/api/bc06bcd794ade842/forecast/q/Canada/Toronto.json')
		open url do |fw|
			json_string = fw.read
			temp_week = JSON.parse(json_string)
			day0 = temp_week['forecast']['simpleforecast']['forecastday'][0]['date']['weekday']
			day0_high = temp_week['forecast']['simpleforecast']['forecastday'][0]['high']['fahrenheit']
			day0_low = temp_week['forecast']['simpleforecast']['forecastday'][0]['low']['fahrenheit']
			day1 = temp_week['forecast']['simpleforecast']['forecastday'][1]['date']['weekday']
			day1_high = temp_week['forecast']['simpleforecast']['forecastday'][1]['high']['fahrenheit']
			day1_low = temp_week['forecast']['simpleforecast']['forecastday'][1]['low']['fahrenheit']
			day2 = temp_week['forecast']['simpleforecast']['forecastday'][2]['date']['weekday']
			day2_high = temp_week['forecast']['simpleforecast']['forecastday'][2]['high']['fahrenheit']
			day2_low = temp_week['forecast']['simpleforecast']['forecastday'][2]['low']['fahrenheit']
			fw = "The 3-day temperature for #{location} on #{day0} has a high of #{day0_high} and a low of #{day0_low}. #{day1} has a high of #{day1_high} and a low of #{day1_low}. #{day2} has a high of #{day2_high} and a low of #{day2_low}."
		end
	end
end

#include timestamp. Check the weather every half hour.
#check the weather everytime the weather was more than 30 minutes ago, time.now + 30.minutes
#throttling our weather call. 