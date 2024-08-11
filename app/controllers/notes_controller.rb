class NotesController < ApplicationController
  before_action :set_note, only: %i[show edit update destroy]

  # GET /notes or /notes.json
  def index
    @q = Note.where(user_id: current_user.id).ransack(params[:q])

    if params[:q].present?
      title_condition = params[:q][:title_cont].present? ? "LOWER(title) LIKE :title" : nil
      content_condition = params[:q][:content_cont].present? ? "LOWER(content) LIKE :content" : nil
      topic_condition = params[:q][:topic_name_cont].present? ? "LOWER(topics.name) LIKE :topic_name" : nil

      conditions = [title_condition, content_condition, topic_condition].compact.join(' AND ')

      # Sort by title
      @notes = Note.joins(:topic)
                   .where(user_id: current_user.id)
                   .where(conditions, 
                          title: "%#{params[:q][:title_cont]&.downcase}%", 
                          content: "%#{params[:q][:content_cont]&.downcase}%", 
                          topic_name: "%#{params[:q][:topic_name_cont]&.downcase}%")
                   .distinct
                   .order(title: :asc)  # Sort by title in ascending order
                   .page(params[:page])
                   .per(6)  # Adjust per page as needed
    else
      @notes = Note.where(user_id: current_user.id)
                   .order(title: :asc)  # Sort by title in ascending order
                   .page(params[:page])
                   .per(6)  # Adjust per page as needed
    end

    # Add breadcrumbs
    add_breadcrumb "Home", root_path
    add_breadcrumb "Notes", notes_path
  end

  # GET /notes/1 or /notes/1.json
  def show
    # Clear existing breadcrumbs
    clear_breadcrumbs

    # Add breadcrumbs
    add_breadcrumb "Home", root_path
    add_breadcrumb "Topics", topics_path(topic_type: @note.topic.topic_type)
    add_breadcrumb @note.topic.name, topic_path(@note.topic)
    add_breadcrumb @note.title, note_path(@note)

    respond_to do |format|
      format.html # Renders the default show view
      format.js   # Renders the show.js.erb file
    end
  end

  # GET /notes/new
  def new
    @note = Note.new(topic_id: params[:topic_id])
    if params[:preview] && params[:content].present?
      @markdown_preview = render_markdown(params[:content])
      @note.content = params[:content]
    end

    # Clear existing breadcrumbs
    clear_breadcrumbs

    # Add breadcrumbs
    add_breadcrumb "Home", root_path
    add_breadcrumb "Topics", topics_path(topic_type: params[:topic_type])
    add_breadcrumb Topic.find(params[:topic_id]).name, topic_path(params[:topic_id])
    add_breadcrumb "New Note", new_note_path
  end

  # GET /notes/1/edit
  def edit
    # Clear existing breadcrumbs
    clear_breadcrumbs

    # Add breadcrumbs
    add_breadcrumb "Home", root_path
    add_breadcrumb "Topics", topics_path(topic_type: @note.topic.topic_type)
    add_breadcrumb @note.topic.name, topic_path(@note.topic)
    add_breadcrumb @note.title, note_path(@note)
    add_breadcrumb "Edit", edit_note_path(@note)
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id

    respond_to do |format|
      if @note.save
        format.html { redirect_to topic_path(@note.topic_id), notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { redirect_to new_note_path(topic_id: @note.topic_id), alert: @note.errors.full_messages.join(", ") }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to topic_path(@note.topic_id), notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy!

    respond_to do |format|
      format.html { redirect_to topic_path(@note.topic_id), notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST /notes/preview
  def preview
    render json: { preview: render_markdown(params[:content]) }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_note
    @note = Note.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def note_params
    params.require(:note).permit(:title, :content, :user_id, :topic_id, :note_image)
  end

  # Clear existing breadcrumbs to prevent duplication
  def clear_breadcrumbs
    @breadcrumbs = []
  end
end
