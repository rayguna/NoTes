class PagesController < ApplicationController
  before_action :authenticate_user!

  def navigate
    @selected_year = params[:year] ? params[:year].to_i : Date.today.year
    @topics_data = (1..12).map do |month|
      Topic.where(user_id: current_user.id, created_at: Date.new(@selected_year, month).all_month).count
    end.join(",")
  
    Rails.logger.debug("Topics data: #{@topics_data}")
  
    # Run the Python script and capture the output
    script_output = `python3 lib/assets/python/generate_chart.py #{@topics_data} #{@selected_year}`
    Rails.logger.debug("Script Output: #{script_output}")
  
    begin
      # Plotly returns the full HTML block needed to render the plot
      @plotly_html = script_output.strip
  
      Rails.logger.debug("Generated Plotly HTML: #{@plotly_html}")
    rescue StandardError => e
      Rails.logger.error("Error processing script output: #{e.message}")
      @plotly_html = ""
    end
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
