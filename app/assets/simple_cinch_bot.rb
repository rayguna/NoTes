# simple_cinch_bot.rb
require 'cinch'

class SimpleBot
  include Cinch::Plugin

  match /hello/i, method: :greet
  match /find.*topic (.+)/i, method: :search_topic
  match /find.*title (.+)/i, method: :search_title
  match /find.*content (.+)/i, method: :search_content

  def greet(m)
    m.reply "Hello, #{m.user.nick}!"
  end

  def search_topic(m, topic)
    m.reply "You want to search for topic: #{topic}"
  end

  def search_title(m, title)
    m.reply "You want to search for title: #{title}"
  end

  def search_content(m, content)
    m.reply "You want to search for content: #{content}"
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = "SimpleBot"
    c.server = "irc.freenode.net"
    c.channels = ["#cinch-bot"]
    c.plugins.plugins = [SimpleBot]
  end
end

bot.start
