class ImagesController < ApplicationController
  def index
    @images = Image.includes(:faces).all
  end

  def show
    @image = Image.includes(:faces).find(params[:id])
  end
end
