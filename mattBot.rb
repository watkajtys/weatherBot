require_relative "weather"
require 'socket'

class Bot
	attr_accessor :server
	def initialize
		@server = 'chat.freenode.net'  #in runner
		@port = '6667'
		@nick = 'BetterWeatherBot'
		@channel = '#bitmaker'
		@response_prompt = 'privmsg #bitmaker :'
		@callings = ['current', 'forecast', 'weather']
	end

	def run
		responses = {
			['current'] => current,
			['forecast'] => forecast
		}

		until server.eof? do 
			msg = @server.gets.downcase
			puts msg

			matched_keyword = []

			wasCalled = false

			@callings.each do |c|
				if msg.include? c
					matched_keyword << c
					wasCalled = true
				end
			end

			if msg.include? @response_prompt and wasCalled
				server.puts "PRIVMSG #{@channel} : #{responses[matched_keyword]}"
			end
		end
	end

	def current
		new_weather_conditions = WeatherReporter.new
		return new_weather_conditions.get_conditions
	end

	def forecast
		new_weather_forecast = WeatherReporter.new
		return new_weather_forecast.get_forecast_today
	end

	def server_connect
		@server = TCPSocket.open(@server,@port)
		server.puts "USER WeatherBot 0 * WeatherBot"
		server.puts "NICK #{@nick}"
		server.puts "JOIN #{@channel}"
		server.puts "PRIVMSG #{@channel} :Hi, I'm WeatherBot. Ask me for the current conditions or for the forcast today!"
	end
end

weatherBot = Bot.new
weatherBot.server_connect
weatherBot.run