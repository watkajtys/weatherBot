require 'test/unit'
require_relative 'mattBot'

class BotTest < Test::Unit::TestCase
	def test_initialize_has_server
		bot = Bot.new
		assert_equal "PRIVMSG #{@channel} :Weather Bot reporting in!" bot.server_connect
	end
end