class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    @search_results = { notes: [], topics: [] }

    search_query = params[:all_fields].to_s

    # Fetch all topics owned by the current user
    user_topics = current_user.topics

    # Fetch all topics shared with the current user
    shared_topic_ids = SharedTopic.where(shared_user_id: current_user.id).pluck(:topic_id)
    shared_topics = Topic.where(id: shared_topic_ids)

    # Combine user topics and shared topics manually
    accessible_topic_ids = (user_topics.pluck(:id) + shared_topic_ids).uniq
    accessible_topics = Topic.where(id: accessible_topic_ids)

    if search_query.present?
      # Search for topics using pg_search
      @search_results[:topics] = Topic.search_by_name(search_query)

      # Search for notes within accessible topics
      @search_results[:notes] = Note.joins(:topic).where(topic: accessible_topics)
                                   .where('notes.title ILIKE :query OR notes.content ILIKE :query', query: "%#{search_query}%")
    else
      # Handle case when there is no search query
      if params[:topic_name_cont].present?
        @search_results[:topics] = Topic.search_by_name(params[:topic_name_cont])
      end

      if params[:content_cont].present?
        @search_results[:notes] = Note.joins(:topic).where(topic: accessible_topics)
                                      .where('notes.content ILIKE ?', "%#{params[:content_cont]}%")
      end
    end
  end
end
