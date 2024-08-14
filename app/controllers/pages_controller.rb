class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:landing]

  before_action :authenticate_user!, only: [:navigate]

  def navigate
    @months = (1..12).map { |m| Date::MONTHNAMES[m] }
    
    if params[:show_chart] == "true"
      selected_year = params[:year] ? params[:year].to_i : Date.today.year
      @topics_data = (1..12).map do |month|
        Topic.where(user_id: current_user.id, created_at: Date.new(selected_year, month).all_month).count
      end
      @notes_data = (1..12).map do |month|
        Note.where(user_id: current_user.id, created_at: Date.new(selected_year, month).all_month).count
      end
    else
      @topics_data = []
      @notes_data = []
    end
  end

  def teases
    # Publicly accessible action
  end

  def tools
    if params[:user_input]
      input_text = format_notes(Note.where(user_id: current_user.id))
      question_scope = params[:question_scope]
      @chatbot = render_markdown(run_python_script("lib/assets/python/chatbot.py", params[:user_input], input_text, question_scope))
    end

    # Use Ransack
    @q = Note.where(user_id: current_user.id).ransack(params[:q])
    @notes = @q.result(distinct: true)
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
end
