class EbooksController < ApplicationController

  def index
    @ebooks = Ebook.all
  end

  def show
    @ebook = Ebook.find(params[:id])
    @ebook.increment!(:page_visit_count)
  end

  def new
    @ebook = Ebook.new
  end

  def create
    @ebook = Ebook.new(ebook_params)
    if @ebook.save
      redirect_to @ebook, notice: "Ebook created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @ebook = Ebook.find(params[:id])
  end

  def update
    @ebook = Ebook.find(params[:id])
    if @ebook.update(ebook_params)
      redirect_to @ebook, notice: "Ebook updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ebook = Ebook.find(params[:id])
    @ebook.destroy
    redirect_to ebooks_path, notice: "Ebook deleted successfully!"
  end

  def advance_status
    @ebook = Ebook.find(params[:id])
    new_status = case @ebook.status
                when "draft" then "pending"
                when "pending" then "live"
                else @ebook.status
                end
    @ebook.update_column(:status, new_status)
    redirect_to @ebook, notice: "Ebook status updated to #{new_status}!"
  end

  def download_preview
    @ebook = Ebook.find(params[:id])
    @ebook.increment!(:preview_view_count)
    redirect_to rails_blob_path(@ebook.preview_pdf, disposition: "attachment")
  end

  private

  def ebook_params
    params.require(:ebook).permit(:title, :description, :price, :status, :user_id, :preview_pdf, :cover_image)
  end

end