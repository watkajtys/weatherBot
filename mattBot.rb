require_relative "weather"
require 'socket'

class Bot
	def initialize
		@server = 'chat.freenode.net'
		@port = '6667'
		@nick = 'WeatherBot'
		@channel = '#bitmaker'
		@response_prompt = 'privmsg #bitmaker :'
		@callings = ['weather', 'temperature', 'current_conditions']
	end
end

class Connect
	attr_reader :server, :port, :channel
	def initialize
		@server = 'chat.freenode.net'
		@port = '6667'
		@channel = '#bitmaker'
	end

	def server_connect
		server = TCPSocket.open(server,port)
	end
end