class TeasesController < ApplicationController

  def create_teases
    # Code for the create_teases action
  end

  def view_teases
    # Code for the view_teases action
  end

  def new
    @tease = Tease.new
  end

  def create
    @tease = Tease.new(tease_params)
    if @tease.save
      redirect_to @tease, notice: 'Tease was successfully created.'
    else
      render :new
    end
  end

  def show
    @tease = Tease.find(params[:id])
  end

  def edit
    @tease = Tease.find(params[:id])
  end

  def update
    @tease = Tease.find(params[:id])
    if @tease.update(tease_params)
      redirect_to @tease, notice: 'Tease was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @tease = Tease.find(params[:id])
    @tease.destroy
    redirect_to teases_url, notice: 'Tease was successfully destroyed.'
  end

  private

  def tease_params
    params.require(:tease).permit(:question, :answer, :user_id, :category)
  end
end
