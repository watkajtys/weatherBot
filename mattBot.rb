require_relative "weather"
require 'socket'

class Bot
	attr_accessor :server, :msg
	def initialize
		@current_reporter = WeatherReporter.new
		@forecast_reporter = WeatherReporter.new
		@temp_reporter = WeatherReporter.new
		@server = 'chat.freenode.net'  #in runner
		@port = '6667'
		@nick = 'BetterWeatherBot'
		@channel = '#bitmaker'
		@response_prompt = 'privmsg #bitmaker :'
		@callings = ['current', 'forecast', 'temperature']
	end

	def respond
		responses = {
			['current'] => current,
			['forecast'] => forecast,
			['temperature'] => temp
		}

		until server.eof? do 
			@msg = @server.gets.downcase
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
			elsif msg.include? "ping"
				server.puts "PRIVMSG #{@channel}" + msg.gsub("ping", "PONG")
			end
		end
	end

	def current
		@current_reporter.get_conditions
	end

	def forecast
		@forecast_reporter.get_forecast_today
	end

	def temp
		@temp_reporter.get_temperatures_week
	end


	def server_connect
		@server = TCPSocket.open(@server,@port)
		server.puts "USER WeatherBot 0 * WeatherBot"
		server.puts "NICK #{@nick}"
		server.puts "JOIN #{@channel}"
		server.puts "PRIVMSG #{@channel} :Hi, I'm WeatherBot. Ask me CURRENT for the current conditions, FORECAST for the forcast today, or TEMPERATURE for the temperature for the next three days!!"
	end
end

weatherBot = Bot.new
weatherBot.server_connect
weatherBot.respond











