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

      @notes = Note.joins(:topic)
                   .where(user_id: current_user.id)
                   .where(conditions, 
                          title: "%#{params[:q][:title_cont]&.downcase}%", 
                          content: "%#{params[:q][:content_cont]&.downcase}%", 
                          topic_name: "%#{params[:q][:topic_name_cont]&.downcase}%")
                   .distinct.page(params[:page]).per(6)  # Adjust per page as needed
    else
      @notes = Note.where(user_id: current_user.id).page(params[:page]).per(6)  # Adjust per page as needed
    end
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new(topic_id: params[:topic_id])
    if params[:preview] && params[:content].present?
      @markdown_preview = render_markdown(params[:content])
      @note.content = params[:content]
    end
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id

    if params[:preview_button]
      redirect_to new_note_path(topic_id: @note.topic_id, content: @note.content, preview: true)
    else
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_note
    @note = Note.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def note_params
    params.require(:note).permit(:title, :content, :user_id, :topic_id)
  end

  def render_markdown(text)
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    markdown.render(text).html_safe
  end
end
