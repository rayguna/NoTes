class TopicsController < ApplicationController
  before_action :set_topic, only: %i[show edit update destroy]

  # GET /topics or /topics.json
  def index
    @topic_type = params[:topic_type] || 'note' # Default topic type if not provided
    @view_mode = params[:display_as] || 'default' # Default view mode if not provided
  
    @topics = Topic.where(user_id: current_user.id, topic_type: @topic_type)
                   .page(params[:page])
                   .per(6)
    
    @q = Note.where(user_id: current_user.id).ransack(params[:q])
    @notes = @q.result(distinct: true)
  
    # Sort table
    @sort_topics = @topics.order(params[:sort])
  end
  

  # GET /topics/1 or /topics/1.json
  def show
    @q = @topic.notes.ransack(params[:q])
    per_page = params[:per_page] || 6
    @notes = @q.result(distinct: true)
               .page(params[:page])
               .per(per_page)
  end

  # GET /topics/new
  def new
    @topic_type = params[:topic_type] || 'note'
    @topic = Topic.new(topic_type: @topic_type)
  end

  # GET /topics/1/edit
  def edit
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
        format.html { redirect_to topic_url(@topic, topic_type: @topic.topic_type), notice: "Topic was successfully updated." }
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
    params.require(:topic).permit(:name, :user_id, :topic_type, :avatar)
  end
  
end
