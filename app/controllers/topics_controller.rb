class TopicsController < ApplicationController
  before_action :set_topic, only: %i[show edit update destroy]

  # GET /topics or /topics.json
  def index
    # Fetch topics of the current user with the topic_type 'note'
    @topics = Topic.where(user_id: current_user.id, topic_type: 'note')
                   .order(name: :asc)  # Sort by name in ascending order
                   .page(params[:page])
                   .per(6)
    
    # Capture the topic_type parameter for any logic you need
    @topic_type = params[:topic_type]

    # Setup the Ransack search object
    @q = Note.where(user_id: current_user.id).ransack(params[:q])
    @notes = @q.result(distinct: true)
  end

  # GET /topics/1 or /topics/1.json
  def show
    # Prepare a Ransack object for searching notes within a specific topic
    @q = @topic.notes.ransack(params[:q])
    per_page = params[:per_page] || 6  # Default to 6 if not provided
    @notes = @q.result(distinct: true)
               .order(title: :asc)  # Sort by title in ascending order
               .page(params[:page])
               .per(per_page)
  end

  # GET /topics/new
  def new
    @topic = Topic.new(topic_type: 'note') # Set default topic_type to 'note'
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
        format.html { redirect_to topics_path, notice: "Topic was successfully created." }
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
        format.html { redirect_to topic_url(@topic), notice: "Topic was successfully updated." }
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
      format.html { redirect_to topics_url, notice: "Topic was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_topic
    @topic = Topic.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def topic_params
    params.require(:topic).permit(:name, :user_id, :topic_type)
  end
end
