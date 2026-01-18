class KittensController < ApplicationController
  def new
    @kitten = Kitten.new
  end

  def create
    @kitten ||= Kitten.build(kitten_params)
    if @kitten.save
      flash[:notice] = "Kitten created!"
      redirect_to kitten_path(@kitten)
    else
      flash[:alert] = "Kitten was not created!"
      render :new, status: :bad_request
    end
  end

  def index
    @kittens ||= Kitten.all
    respond_to do |format|
      format.html
      format.json { render json: @kittens }
    end
  end

  def show
    begin
      @kitten ||= Kitten.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Kitten with ID: #{params[:id]} not found!"
      redirect_to kittens_path, status: :see_other
    end
    respond_to do |format|
      format.html
      format.json { render json: @kitten }
    end
  end

  def destroy
    begin
      kitten = Kitten.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Could not find kitten with ID: #{params[:id]} to delete!"
      redirect_to kittens_path, status: :see_other
    end
    if kitten && kitten.destroy
      flash[:notice] = "Kitten destroyed!"
      redirect_to kittens_path, status: :see_other
    else
      flash.now[:alert] = "Could not destroy kitten with ID: #{params[:id]}"
      render :show, status: :bad_request
    end
  end

  def update
    kitten = Kitten.find(params[:id])
    if kitten.update(kitten_params)
      flash[:notice] = "Kitten updated!"
      redirect_to kitten_path(kitten)
    else
      flash.now[:alert] = "Could not update kitten with ID: #{params[:id]}"
      render :edit, status: :bad_request
    end
  end

  def edit
    begin
      @kitten = Kitten.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      if kitten
        redirect_to kitten_path(@kitten)
      else
        flash.now[:alert] = "Could not edit kitten with ID: #{params[:id]}"
        render :show, status: :bad_request
      end
    end
  end

  private

  def kitten_params
    params.expect(kitten: [ :id, :name, :age ])
  end
end
