class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  # skip_after_action :verify_authorized

  def index
    if user_signed_in? 
      redirect_to :navigate
    else
      render :index
    end
  end

  def about
  end

end
