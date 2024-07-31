class TeasesController < ApplicationController
  before_action :set_tease, only: %i[show edit update destroy]

  def create_teases
    @topic = Topic.new
  end

  def view_teases
    @topics = Topic.where(user_id: current_user.id, topic_type: 'teases')
                   .order(name: :asc)  # Sort by name in ascending order
                   .page(params[:page])
                   .per(6)

    @q = Note.where(user_id: current_user.id).ransack(params[:q])
    @notes = @q.result(distinct: true)
  end

  def new
    @tease = Tease.new
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
    @topic.topic_type = 'teases'  # Ensure the topic_type is set to 'teases'

    respond_to do |format|
      if @topic.save
        format.html { redirect_to view_teases_teases_path, notice: "Tease was successfully created." }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :create_teases, status: :unprocessable_entity }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    if @tease.update(tease_params)
      redirect_to @tease, notice: 'Tease was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @tease.destroy
    redirect_to teases_url, notice: 'Tease was successfully destroyed.'
  end

  private

  def set_tease
    @tease = Tease.find(params[:id])
  end

  def tease_params
    params.require(:tease).permit(:question, :answer, :user_id, :category)
  end

  def topic_params
    params.require(:topic).permit(:name, :user_id, :topic_type)
  end
end
