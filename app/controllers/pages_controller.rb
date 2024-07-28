class PagesController < ApplicationController
  before_action :authenticate_user!
  
  def navigate
  end

  def tools
    if params[:user_input]
      @chatbot = run_python_script("lib/assets/python/chatbot.py", params[:user_input])
    end
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
