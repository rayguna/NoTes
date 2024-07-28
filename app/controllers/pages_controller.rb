class PagesController < ApplicationController
  before_action :authenticate_user!
  
  def home
    user_input = "10"
    @heart = run_python_script("lib/assets/python/heart.py", user_input)

    user_input2 = "What is the best color on earth?"
    @chatbot = run_python_script("lib/assets/python/chatbot.py", user_input2)
  end

  private

  def run_python_script(script_path, user_input)
    begin
      result = `python3 #{script_path} #{Shellwords.escape(user_input)}`
      raise "Python script error" if result.blank?
      result
    rescue => e
      Rails.logger.error("Error running Python script: #{e.message}")
      "Error executing script"
    end
  end
end
