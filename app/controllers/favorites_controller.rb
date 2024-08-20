class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def toggle
    favoritable = find_favoritable
    favorite = current_user.favorites.find_by(favoritable: favoritable)

    if favorite
      favorite.destroy
      @favorite_status = false
    else
      current_user.favorites.create(favoritable: favoritable)
      @favorite_status = true
    end

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js   # This will render `toggle.js.erb`
    end
  end

  private

  def find_favoritable
    if params[:favoritable_type] == "Topic"
      Topic.find(params[:favoritable_id])
    elsif params[:favoritable_type] == "Note"
      Note.find(params[:favoritable_id])
    else
      raise "Unknown favoritable type"
    end
  end
end
