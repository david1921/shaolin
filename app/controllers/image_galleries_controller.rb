class ImageGalleriesController < ApplicationController
  def show
    @library_images = LibraryImage.all_active
    render :layout => !params[:ajax].present?
  end
end

