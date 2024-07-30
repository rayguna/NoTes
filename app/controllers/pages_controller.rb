class PagesController < ApplicationController
  before_action :authenticate_user!
  
  def navigate
  end

  def teases
  end

  def tools
    if params[:user_input]
      input_text = format_notes(Note.where(user_id: current_user.id))
      question_scope = params[:question_scope]
      @chatbot = render_markdown(run_python_script("lib/assets/python/chatbot.py", params[:user_input], input_text, question_scope))
    end
  end

  private

  def format_notes(notes)
    notes.map do |note|
      "Title: #{note.title}\nContent: #{note.content}\nTopic: #{note.topic.name}"
    end.join("\n\n")
  end

  def run_python_script(script_path, user_input, input_text, question_scope)
    begin
      result = `python3 #{script_path} #{Shellwords.escape(user_input)} #{Shellwords.escape(input_text)} #{Shellwords.escape(question_scope)}`
      raise "Python script error" if result.blank?
      result
    rescue => e
      Rails.logger.error("Error running Python script: #{e.message}")
      "Error executing script"
    end
  end
end
