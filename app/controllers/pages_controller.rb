class PagesController < ApplicationController
  before_action :authenticate_user!
  
  def home
    user_input = "10"
    @heart = `python3 lib/assets/python/heart.py #{user_input}`
  end
end
