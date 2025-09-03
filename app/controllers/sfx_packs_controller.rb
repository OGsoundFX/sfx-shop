class SfxPacksController < ApplicationController
  def show
    @pack = SfxPack.includes(:sound_designer).includes(photos_attachments: :blob).find(params[:id])
    unless @pack.live? || @pack.sound_designer.user == current_user
      redirect_to root_path, alert: "Pack unavailable"
    end
    @designer = @pack.sound_designer
    @designer_name = "#{@designer.first_name} #{@designer.last_name}"
    @average_rating = (@pack.reviews.sum { |review| review.rating } / @pack.reviews.count.to_f).ceil(1) if @pack.reviews.present?
    current_sales = Sale.where("end_date > ?", Date.current)
    current_sales.each do |sale|
      sale.packs.each do |pack_id|
        @discount = sale.percentage if @pack.id == pack_id
      end
    end
  end

  def create
    @designer = SoundDesigner.find(params[:sound_designer_id])
    @sfx_pack = SfxPack.new(sfx_pack_params)
    @sfx_pack.sound_designer = @designer

    # taking care of the category and tags fields
    params[:sfx_pack][:category].shift
    params[:sfx_pack][:tags].shift

    @sfx_pack.category = params[:sfx_pack][:category].join(", ")
    @sfx_pack.tags = params[:sfx_pack][:tags].join(", ")

    @sfx_pack.status = "submitted"
    # creating the SKU
    if @designer.sfx_packs.count == 0
      increment = "001"
    else
      sfx_packs = @designer.sfx_packs.where.not(sku: nil)
      increment = (sfx_packs.last.sku[6, 3].to_i + 1).to_s
      case increment.size
      when 1 then incement = "00" + increment
      when 2 then incement = "0" + increment
      end
    end
    @sfx_pack.sku = @designer.first_name[0].capitalize + @designer.last_name[0].capitalize + "PACK" + increment

    if @sfx_pack.save
      redirect_to designer_listings_path
    else
      render "designer_dashboards/pack_form", status: :unprocessable_entity
    end
  end

  def update
    @sfx_pack = SfxPack.find(params[:id])
    @designer = @sfx_pack.sound_designer

    # be careful, only execute the following lines if a new photo or pdf is added
    @sfx_pack.sound_list.purge if @sfx_pack.sound_list.present? && sfx_pack_params[:sound_list].present?
    @sfx_pack.photos.purge if @sfx_pack.photos.present? && sfx_pack_params[:photos].present?

    @sfx_pack.update(sfx_pack_params)
    @sfx_pack.submitted! if @sfx_pack.removed?
    if @sfx_pack.save
      redirect_to designer_listings_path
    else
      render "designer_dashboards/update_pack_form", status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def sfx_pack_params
    params.require("sfx_pack").permit(:title, :size_mb, :description, :photos, :price, :number_of_tracks, :duration, :link, :product_link, :sound_list)
  end
end
