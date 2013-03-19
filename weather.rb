require 'open-uri'
require 'json'
require 'active_support/all'

class WeatherReporter
	attr_reader :location

	def initialize
		@location = 'Toronto'
	end

	def get_conditions
		url = ('http://api.wunderground.com/api/bc06bcd794ade842/geolookup/conditions/q/Canada/Toronto.json')
		now = Time.now
		if @forecast_time == nil || (@forecast_time + 30.minutes) < now
			@forecast_time = now
			open url do |f|
				json_string = f.read
				current_conditions = JSON.parse(json_string)
				conditions_parse = current_conditions['current_observation']

				location = conditions_parse['location']['city']
				temp_f = conditions_parse['temperature_string']
				wind_f = conditions_parse['wind_string']
				feels_f = conditions_parse['feelslike_string']
				weather_f = conditions_parse['weather']

				@current = "It is currently #{temp_f} in #{location}. #{weather_f} with wind #{wind_f}. It feels like #{feels_f}."
			end
		else
			return @current
		end	
	end

	def get_forecast_today
		url = ('http://api.wunderground.com/api/bc06bcd794ade842/forecast/q/Canada/Toronto.json')
		now = Time.now
		if @forecast_time == nil || (@forecast_time + 30.minutes) < now
			@forecast_time = now
			open url do |f|
				json_string = f.read
				forecast_today = JSON.parse(json_string)
				forecast_day = forecast_today['forecast']['txt_forecast']['forecastday']

				day = forecast_day[0]['title']
				day_text = forecast_day[0]['fcttext']
				night = forecast_day[1]['title']
				night_text = forecast_day[1]['fcttext']

				@forecast = "The forecast for #{location} on #{day} is #{day_text} #{night} will be #{night_text}"
			end
		else
			return @forecast
		end
	end

	def get_temperatures_week
		url = ('http://api.wunderground.com/api/bc06bcd794ade842/forecast/q/Canada/Toronto.json')
		now = Time.now
		if @forecast_time == nil || (@forecast_time + 30.minutes) < now
			@forecast_time = now
			open url do |fw|
				json_string = fw.read
				temp_week = JSON.parse(json_string)
				forecast_day = temp_week['forecast']['simpleforecast']['forecastday']

				forecast_text = forecast_day.map do |day|
					weekday = day['date']['weekday']
					high = day['high']['fahrenheit']
					low = day['low']['fahrenheit']
					s = "The 3-day temperature for #{location} on #{weekday} "
					s += "has a high of #{high} and a low of #{low}."
				end

				@temp_week = forecast_text.join(" ")
			end
		else
			return @temp_week
		end
	end
end