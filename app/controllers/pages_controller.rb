class PagesController < ApplicationController
  before_action :authenticate_user!

  def navigate
    @selected_year = params[:year] ? params[:year].to_i : Date.today.year
    @topics_data = (1..12).map do |month|
      Topic.where(user_id: current_user.id, created_at: Date.new(@selected_year, month).all_month).count
    end.join(",")

    # Capture the topic_type parameter when the link is clicked.
    @topic_type = params[:topic_type]

    Rails.logger.debug("Topics data: #{@topics_data}")
    
    image_full_path = run_python_script("lib/assets/python/generate_chart.py", @topics_data, @selected_year)
    Rails.logger.debug("Image full path: #{image_full_path}")
    
    @chart_image_path = image_full_path.sub('public/', '') if image_full_path.present? # Remove 'public/' from the path
    Rails.logger.debug("Chart image path: #{@chart_image_path}")
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
end
