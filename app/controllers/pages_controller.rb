class PagesController < ApplicationController
  before_action :authenticate_user!
  
  def navigate
  end

  def teases
  end

  def tools
    if params[:user_input]
      user_input = params[:user_input]
      document = <<~DOC
      Artificial Intelligence (AI) is the simulation of human intelligence in machines that are programmed to think like humans and mimic their actions. The term may also be applied to any machine that exhibits traits associated with a human mind such as learning and problem-solving.

      AI is being used across different industries and sectors including healthcare, finance, education, and transportation. In healthcare, AI is being used for diagnosis, treatment recommendations, and personalized medicine. In finance, AI helps in fraud detection and financial forecasting.

      The development of AI involves a variety of disciplines such as computer science, mathematics, psychology, neuroscience, cognitive science, linguistics, operations research, economics, and others. The field was founded on the claim that human intelligence can be so precisely described that a machine can be made to simulate it.

      AI research is divided into subfields that often fail to communicate with each other. These subfields are based on technical considerations, such as particular goals (e.g. robotics or machine learning), the use of particular tools (e.g. logic or neural networks), or deep philosophical differences. Subfields have also been organized based on social factors (particular institutions or the work of particular researchers).

      The main approaches used by AI to learn information are supervised learning, unsupervised learning, and reinforcement learning.

      Blue is the color of the sky. Sometimes, the sky color can also be red, or even purple. It depends on the weather.
      DOC

      result = `TRANSFORMERS_CACHE=./cache/huggingface python3 lib/assets/python/chatbot.py "#{user_input}" "#{document}"`
      @chatbot = result.strip
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
