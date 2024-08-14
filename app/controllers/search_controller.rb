# app/controllers/search_controller.rb
class SearchController < ApplicationController
  def index
    @search_results = { notes: [], topics: [] }

    if params[:all_fields].present?
      decrypted_notes = Note.all.select do |note|
        decrypted_title = note.decrypt(:title)
        decrypted_content = note.decrypt(:content)
        decrypted_topic_name = note.topic.decrypt(:name)
        
        decrypted_title.include?(params[:all_fields]) ||
        decrypted_content.include?(params[:all_fields]) ||
        decrypted_topic_name.include?(params[:all_fields])
      end

      decrypted_topics = Topic.all.select do |topic|
        decrypted_name = topic.decrypt(:name)
        # Remove description if it doesn't exist
        # decrypted_description = topic.decrypt(:description) if topic.respond_to?(:description)
        
        decrypted_name.include?(params[:all_fields])
      end

      @search_results[:notes] = decrypted_notes
      @search_results[:topics] = decrypted_topics
    else
      if params[:topic_name_cont].present?
        @search_results[:topics] = Topic.all.select do |topic|
          decrypted_name = topic.decrypt(:name)
          decrypted_name.include?(params[:topic_name_cont])
        end
      end

      if params[:content_cont].present?
        @search_results[:notes] = Note.all.select do |note|
          decrypted_content = note.decrypt(:content)
          decrypted_content.include?(params[:content_cont])
        end
      end
    end
  end
end
