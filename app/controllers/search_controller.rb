class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    @search_results = { notes: [], topics: [] }

    search_query = params[:all_fields].to_s
    topic_name_cont = params[:topic_name_cont]
    content_cont = params[:content_cont]

    accessible_topics = fetch_accessible_topics
    @search_results[:topics] = search_topics(search_query, topic_name_cont, accessible_topics)
    @search_results[:notes] = search_notes(search_query, content_cont, accessible_topics) if search_query.present?
  end

  private

  def fetch_accessible_topics
    user_topic_ids = current_user.topics.pluck(:id)
    shared_topic_ids = SharedTopic.where(shared_user_id: current_user.id).pluck(:topic_id)
    Topic.where(id: (user_topic_ids + shared_topic_ids).uniq)
  end

  def search_topics(query, topic_name_cont, accessible_topics)
    if query.present?
      Topic.search_by_name(query).where(id: accessible_topics.pluck(:id))
    elsif topic_name_cont.present?
      Topic.search_by_name(topic_name_cont)
    else
      accessible_topics
    end
  end

  def search_notes(query, content_cont, accessible_topics)
    notes_scope = Note.joins(:topic).where(topic: accessible_topics)
    
    if query.present?
      notes_scope.where('notes.title ILIKE :query OR notes.content ILIKE :query', query: "%#{query}%")
    elsif content_cont.present?
      notes_scope.where('notes.content ILIKE ?', "%#{content_cont}%")
    else
      notes_scope
    end
  end
end
