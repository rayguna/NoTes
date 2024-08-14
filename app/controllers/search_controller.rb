class SearchController < ApplicationController
  before_action :set_current_user

  def index
    @search_results = { notes: [], topics: [] }

    search_words = params[:all_fields].to_s.split(' ')
    case_sensitive = params[:match_case] == '1' # Assuming '1' indicates match case enabled

    if search_words.present?
      decrypted_notes = current_user.notes.select do |note|
        decrypted_title = decrypt_and_search(note, :title, search_words, case_sensitive)
        decrypted_content = decrypt_and_search(note, :content, search_words, case_sensitive)
        decrypted_topic_name = decrypt_and_search(note.topic, :name, search_words, case_sensitive)
        
        decrypted_title || decrypted_content || decrypted_topic_name
      end

      decrypted_topics = current_user.topics.select do |topic|
        decrypted_name = decrypt_and_search(topic, :name, search_words, case_sensitive)
        decrypted_name
      end

      @search_results[:notes] = decrypted_notes
      @search_results[:topics] = decrypted_topics
    else
      if params[:topic_name_cont].present?
        decrypted_topics = current_user.topics.select do |topic|
          decrypted_name = decrypt_and_search(topic, :name, [params[:topic_name_cont]], case_sensitive)
          decrypted_name
        end
        @search_results[:topics] = decrypted_topics
      end

      if params[:content_cont].present?
        decrypted_notes = current_user.notes.select do |note|
          decrypted_content = decrypt_and_search(note, :content, [params[:content_cont]], case_sensitive)
          decrypted_content
        end
        @search_results[:notes] = decrypted_notes
      end
    end
  end

  private

  def set_current_user
    @current_user = current_user
  end

  def decrypt_and_search(record, attribute, words, case_sensitive)
    decrypted_text = record.decrypt(attribute)
    words.all? do |word|
      if case_sensitive
        decrypted_text.include?(word)
      else
        decrypted_text.downcase.include?(word.downcase)
      end
    end
  end
end
