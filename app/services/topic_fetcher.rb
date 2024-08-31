class TopicFetcher
  def initialize(user, params)
    @user = user
    @topic_type = params[:topic_type] || "note"
    @sort_column = params[:sort] || "lower_name"
    @sort_direction = params[:direction] || "asc"
    @page = params[:page]
    @per_page = params[:per_page] || 6
  end

  def fetch
    Topic.joins("LEFT JOIN shared_topics ON topics.id = shared_topics.topic_id AND shared_topics.shared_user_id = #{@user.id}")
      .joins("LEFT JOIN users AS topic_owners ON topics.user_id = topic_owners.id")
      .joins("LEFT JOIN users AS shared_users ON shared_topics.user_id = shared_users.id")
      .select("topics.*, 
             CASE 
               WHEN shared_topics.id IS NOT NULL THEN topic_owners.email 
               ELSE topic_owners.email 
             END AS author_email, 
             LOWER(topics.name) AS lower_name")
      .where("topics.user_id = :user_id OR shared_topics.shared_user_id = :user_id", user_id: @user.id)
      .where(topic_type: @topic_type)
      .distinct
      .order(Arel.sql("#{@sort_column} #{@sort_direction}"))
      .page(@page)
      .per(@per_page)
  end
end
