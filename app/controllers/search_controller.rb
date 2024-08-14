class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    @search_results = { notes: [], topics: [] }

    search_words = params[:all_fields].to_s.split(' ')
    case_sensitive = params[:match_case] == '1' # Assuming '1' indicates match case enabled

    # Fetch all topics owned by the current user
    user_topics = current_user.topics

    # Fetch all topics shared with the current user
    shared_topic_ids = SharedTopic.where(shared_user_id: current_user.id).pluck(:topic_id)
    shared_topics = Topic.where(id: shared_topic_ids)

    # Combine user topics and shared topics manually
    accessible_topic_ids = (user_topics.pluck(:id) + shared_topic_ids).uniq
    accessible_topics = Topic.where(id: accessible_topic_ids)

    # For debugging: list all accessible topics
    @accessible_topics = accessible_topics

    if search_words.present?
      decrypted_notes = Note.where(topic: accessible_topics).select do |note|
        decrypted_title = decrypt_and_search(note, :title, search_words, case_sensitive)
        decrypted_content = decrypt_and_search(note, :content, search_words, case_sensitive)
        decrypted_topic_name = decrypt_and_search(note.topic, :name, search_words, case_sensitive)
        
        decrypted_title || decrypted_content || decrypted_topic_name
      end

      decrypted_topics = accessible_topics.select do |topic|
        decrypted_name = decrypt_and_search(topic, :name, search_words, case_sensitive)
        decrypted_name
      end

      @search_results[:notes] = decrypted_notes.uniq { |note| note.id }
      @search_results[:topics] = decrypted_topics.uniq { |topic| topic.id }
    else
      if params[:topic_name_cont].present?
        decrypted_topics = accessible_topics.select do |topic|
          decrypted_name = decrypt_and_search(topic, :name, [params[:topic_name_cont]], case_sensitive)
          decrypted_name
        end
        @search_results[:topics] = decrypted_topics.uniq { |topic| topic.id }
      end

      if params[:content_cont].present?
        decrypted_notes = Note.where(topic: accessible_topics).select do |note|
          decrypted_content = decrypt_and_search(note, :content, [params[:content_cont]], case_sensitive)
          decrypted_content
        end
        @search_results[:notes] = decrypted_notes.uniq { |note| note.id }
      end
    end
  end

  private

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
