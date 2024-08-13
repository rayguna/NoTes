class TopicsController < ApplicationController
  VALID_SORT_COLUMNS = %w[name created_at updated_at].freeze
  before_action :set_topic, only: %i[show edit update destroy share]

  # GET /topics or /topics.json
  def index
    @topic_type = params[:topic_type] || 'note' # Default topic type if not provided
    @view_mode = params[:display_as] || 'table' # Default to 'table' view if not provided
  
    @topics = Topic.where(user_id: current_user.id, topic_type: @topic_type)
                   .page(params[:page])
                   .per(6)
    
    @q = Note.where(user_id: current_user.id).ransack(params[:q])
    @notes = @q.result(distinct: true)
  
    # Sort table
    sort_column = VALID_SORT_COLUMNS.include?(params[:sort]) ? params[:sort] : 'name'
    sort_direction = params[:direction] == 'desc' ? 'desc' : 'asc'

    if sort_column == 'name'
      @sort_topics = @topics.order(Arel.sql("LOWER(#{sort_column}) #{sort_direction}"))
    else
      @sort_topics = @topics.order("#{sort_column} #{sort_direction}")
    end

    # Add breadcrumbs
    add_breadcrumb "Home", root_path
    add_breadcrumb "Topics", topics_path(topic_type: @topic_type)
  end
  
  def share
    shared_user_ids = (params[:shared_user_ids] || []).map(&:to_i)
  
    user_ids_to_add = shared_user_ids - SharedTopic.where(topic_id: @topic.id).pluck(:shared_user_id)
    user_ids_to_remove = SharedTopic.where(topic_id: @topic.id, user_id: current_user.id).pluck(:shared_user_id) - shared_user_ids
  
    ActiveRecord::Base.transaction do
      user_ids_to_add.each do |user_id|
        begin
          SharedTopic.find_or_create_by!(topic_id: @topic.id, shared_user_id: user_id) do |shared_topic|
            shared_topic.user_id = current_user.id
          end
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.info "Skipping invalid entry: #{e.message}"
        end
      end
  
      user_ids_to_remove.each do |user_id|
        SharedTopic.where(topic_id: @topic.id, user_id: current_user.id, shared_user_id: user_id).destroy_all
      end
    end
  
    redirect_to @topic, notice: "Topic sharing updated successfully."
  end  
  

  # GET /topics/1 or /topics/1.json
  def show
    @view_mode = params[:display_as] || 'table' # Default to 'table' view if not provided

    @q = @topic.notes.ransack(params[:q])
    per_page = params[:per_page] || 6
    @notes = @q.result(distinct: true)
               .page(params[:page])
               .per(per_page)

    allowed_sorts = %w[name created_at updated_at] # List of allowed columns
    sort_column = allowed_sorts.include?(params[:sort]) ? params[:sort] : "title"
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  
    @sort_notes = @notes.order("#{sort_column} #{sort_direction}")

    # Add breadcrumbs
    add_breadcrumb "Home", root_path
    add_breadcrumb "Topics", topics_path(topic_type: @topic.topic_type)
    add_breadcrumb @topic.name, topic_path(@topic)
  end

  # GET /topics/new
  def new
    @topic_type = params[:topic_type] || 'note'
    @topic = Topic.new(topic_type: @topic_type)

    # Add breadcrumbs
    add_breadcrumb "Home", root_path
    add_breadcrumb "Topics", topics_path(topic_type: @topic_type)
    add_breadcrumb "New Topic", new_topic_path
  end

  # GET /topics/1/edit
  def edit
    # Add breadcrumbs
    add_breadcrumb "Home", root_path
    add_breadcrumb "Topics", topics_path(topic_type: @topic.topic_type)
    add_breadcrumb @topic.name, topic_path(@topic)
    add_breadcrumb "Edit", edit_topic_path(@topic)
  end

  # POST /topics or /topics.json
  def create
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id

    respond_to do |format|
      if @topic.save
        format.html { redirect_to topics_path(topic_type: @topic.topic_type), notice: "Topic was successfully created." }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1 or /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to topics_path(topic_type: @topic.topic_type), notice: "Topic was successfully updated." }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /topics/1 or /topics/1.json
  def destroy
    @topic.destroy!

    respond_to do |format|
      format.html { redirect_to topics_url(topic_type: @topic.topic_type), notice: "Topic was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:name, :user_id, :topic_type)
  end
end
