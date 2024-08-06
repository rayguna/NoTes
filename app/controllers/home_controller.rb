class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    if user_signed_in?
      prepare_navigation_data
    end
  end

  def about
  end

  private

  def prepare_navigation_data
    @months = (1..12).map { |m| Date::MONTHNAMES[m] }
    selected_year = params[:year] ? params[:year].to_i : Date.today.year

    if params[:show_chart] == "true"
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
end
