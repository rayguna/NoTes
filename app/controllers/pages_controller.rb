class PagesController < ApplicationController

  before_action :set_devise_resource, only: [:landing] # or whatever action renders your modal

  # before_action :authenticate_user!
  # Skip authentication for the landing page
  skip_before_action :authenticate_user!, only: [:landing]

  # Landing page action
  def landing
    render "pages/landing"
  end

  def navigate
    @selected_year = params[:year] ? params[:year].to_i : Date.today.year

    @topics_data = (1..12).map do |month|
      Topic.where(user_id: current_user.id, created_at: Date.new(@selected_year, month).all_month).count
    end

    @notes_data = (1..12).map do |month|
      Note.where(user_id: current_user.id, created_at: Date.new(@selected_year, month).all_month).count
    end

    @months = Date::MONTHNAMES[1..12] # Extract month names for labels
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

  def run_python_script(script_path, *args)
    command = "python3 #{script_path} #{args.map { |a| Shellwords.escape(a.to_s) }.join(' ')}"
    result = `#{command}`.strip
    if $?.success?
      result
    else
      Rails.logger.error("Error running Python script: #{result}")
      nil
    end
  end

  def set_devise_resource
    # Ensures that the necessary Devise variables are available
    self.resource = User.new
    self.resource_name = :user
    self.devise_mapping = Devise.mappings[:user]
  end

end
