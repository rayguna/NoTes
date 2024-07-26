class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    @q = Note.where(user_id: current_user.id).ransack(params[:q])

    if params[:q].present?
      title_condition = params[:q][:title_cont].present? ? "LOWER(title) LIKE :title" : nil
      content_condition = params[:q][:content_cont].present? ? "LOWER(content) LIKE :content" : nil

      conditions = [title_condition, content_condition].compact.join(' AND ')

      @notes = Note.where(user_id: current_user.id)
                   .where(conditions, title: "%#{params[:q][:title_cont].downcase}%", content: "%#{params[:q][:content_cont].downcase}%")
                   .distinct
    else
      @notes = Note.where(user_id: current_user.id)
    end
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    # @note = Note.new
    @note = Note.new(topic_id: params[:topic_id])
  end

  # GET /notes/1/edit
  def edit
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :content, :user_id, :topic_id)
    end
end
