class ToolsController < ApplicationController
  before_action :set_tool, only: %i[ show edit update destroy ]

  def index
    @search_query = params[:search_query]

    if @search_query.present?
      logger.debug "Executing search with query: #{@search_query}"

      @notes_results = Note.search(@search_query, fields: ['content'], match: :word_start, misspellings: {edit_distance: 2})
      @topics_results = Topic.search(@search_query, fields: ['name'], match: :word_start, misspellings: {edit_distance: 2})

      logger.debug "Notes results count: #{@notes_results.total_count}"
      logger.debug "Topics results count: #{@topics_results.total_count}"
      logger.debug "Notes results: #{@notes_results.map(&:content)}"
      logger.debug "Topics results: #{@topics_results.map(&:name)}"

      @results = {
        notes: @notes_results,
        topics: @topics_results
      }

      @total_results = @notes_results.total_count + @topics_results.total_count
    else
      @results = {}
      @total_results = 0
    end
  end

  

  # GET /tools or /tools.json
  def index
    @tools = Tool.all
  end

  # GET /tools/1 or /tools/1.json
  def show
  end

  # GET /tools/new
  def new
    @tool = Tool.new
  end

  # GET /tools/1/edit
  def edit
  end

  # POST /tools or /tools.json
  def create
    @tool = Tool.new(tool_params)

    respond_to do |format|
      if @tool.save
        format.html { redirect_to tool_url(@tool), notice: "Tool was successfully created." }
        format.json { render :show, status: :created, location: @tool }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tool.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tools/1 or /tools/1.json
  def update
    respond_to do |format|
      if @tool.update(tool_params)
        format.html { redirect_to tool_url(@tool), notice: "Tool was successfully updated." }
        format.json { render :show, status: :ok, location: @tool }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tool.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tools/1 or /tools/1.json
  def destroy
    @tool.destroy!

    respond_to do |format|
      format.html { redirect_to tools_url, notice: "Tool was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def search_fields(model)
    if params[:fields] == 'all'
      model.searchkick_index.index_mapping['properties'].keys
    else
      Array(params[:fields])
    end
  end
  

  # Use callbacks to share common setup or constraints between actions.
  def set_tool
    @tool = Tool.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tool_params
    params.require(:tool).permit(:search_query, :results)
  end
end
