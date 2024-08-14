# simple_local_chatbot.rb
class SimpleChatbot
  def initialize
    @responses = {
      "hello" => "Hello, human!",
      "how are you" => "I'm just a bot, but I'm doing great! How about you?",
      "goodbye" => "Goodbye! Have a great day!"
    }
  end

  def respond(input)
    input = input.downcase.strip
    @responses[input] || "Sorry, I don't understand that."
  end
end

# Create a new instance of the chatbot
bot = SimpleChatbot.new

# Simulate a conversation loop
puts "Chatbot: Hi there! Type something to chat with me. Type 'exit' to quit."

loop do
  print "You: "
  user_input = gets.chomp
  break if user_input.downcase == "exit"

  puts "Chatbot: #{bot.respond(user_input)}"
end

puts "Chatbot: Chat session ended."
