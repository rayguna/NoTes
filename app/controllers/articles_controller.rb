# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  def index
    if params[:query].present?
      cleaned_query = SearchService.clean_query(params[:query])
      @articles = Note.search_by_content(cleaned_query)
    else
      @q = Note.ransack(params[:q])
      @articles = @q.result
    end
  end
end
