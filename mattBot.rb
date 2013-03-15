require_relative "weather"
require 'socket'

class Bot
	attr_accessor :server
	def initialize
		@server = 'chat.freenode.net'
		@port = '6667'
		@nick = 'WeatherBot'
		@channel = '#bitmaker'
		@response_prompt = 'privmsg #bitmaker :'
		@callings = ['current weather', 'forecast']
	end

	def run
		until server.eof? do 
			msg = @server.gets.downcase
			puts msg

			wasCalled = false
			@callings.each do |c|
				wasCalled = true if msg.include? c
			end
			
			if msg.include? @response_prompt and wasCalled
				server.puts "PRIVMSG #{@channel} : #{current}"
			elsif msg.incl? @response_prompt and wasCalled
				server.puts "PRIVMSG #{@channel} : #{forecast}"
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