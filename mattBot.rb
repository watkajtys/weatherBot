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
		@callings = ['weather', 'temperature', 'current_conditions']
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
				server.puts "PRIVMSG #{@channel} : #{weather}"
			end
		end
	end

	def server_connect
		@server = TCPSocket.open(@server,@port)
		server.puts "USER WeatherBot 0 * WeatherBot"
		server.puts "NICK #{@nick}"
		server.puts "JOIN #{@channel}"
		server.puts "PRIVMSG #{@channel} :Weather Bot reporting in!"
	end
end

weatherBot = Bot.new
weatherBot.server_connect
weatherBot.run