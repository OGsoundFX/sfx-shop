class SfxPacksController < ApplicationController
  def show
    @pack = SfxPack.includes(:sound_designer).includes(photos_attachments: :blob).find(params[:id])
    unless @pack.live? || @pack.sound_designer.user == current_user || current_user.admin?
      redirect_to root_path, alert: "Pack unavailable"
    end
    @designer = @pack.sound_designer
    @designer_name = @designer.artist_name
    @average_rating = (@pack.reviews.sum { |review| review.rating } / @pack.reviews.count.to_f).ceil(1) if @pack.reviews.present?
    current_sales = Sale.where("end_date > ?", Date.current)
    current_sales.each do |sale|
      sale.packs.each do |pack_id|
        @discount = sale.percentage if @pack.id == pack_id
      end
    end
  end

  def index
    @categories = SfxPack.categories
    @designers = SoundDesigner.all

    # Retrieving packs
    @sfx_packs = SfxPack.where(status: "live").includes(:sound_designer).includes(photos_attachments: :blob).all.sort_by(&:display_order)

    # search resutls
    if params[:dropdown] && params[:dropdown] != "all"
      @sfx_packs = SfxPack.where(status: "live").where("title ilike :query OR category ilike :query OR tags ilike :query", query: "%#{params[:dropdown]}%").includes(:sound_designer).includes(photos_attachments: :blob).sort_by(&:display_order)
      @category = params[:dropdown]
    end

    if params[:search]
      @sfx_packs = SfxPack.where(status: "live").where("title ilike :query OR category ilike :query OR tags ilike :query OR description ilike :query", query: "%#{params[:search]}%").includes(:sound_designer).includes(photos_attachments: :blob).sort_by(&:display_order)
      @search = params[:search]
    end

    # annoucements
    if Date.today < Annoucement.last.end_date && Date.today >= Annoucement.last.start_date
      @announcement = Annoucement.last
    end

    # sales
    current_sales = Sale.where("end_date > ?", Date.current)
    @current_sales_list = {}
    current_sales.each do |sale|
      sale.packs.each do |pack_id|
        @current_sales_list[pack_id] = sale.percentage
      end
    end

    if current_sales.count > 0
      @sale_title = current_sales.order("percentage desc").first.title
      @sale_percentage = current_sales.order("percentage desc").first.percentage
    end

    # mailing list subscription
    if current_user
      audience_id = ENV['MAILCHIMP_LIST_ID']
      begin
        @status = Gibbon::Request.lists(audience_id).members(current_user.email).retrieve.body["status"]
      rescue
        @status = "Not Subscribed"
      end
    end
  end

  def create
    @designer = SoundDesigner.find(params[:sound_designer_id])
    @sfx_pack = SfxPack.new(sfx_pack_params)
    @sfx_pack.sound_designer = @designer
    @sfx_pack.display_order = 100

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
    @sfx_pack.sku = @designer.artist_name.slice(0, 2).upcase + "PACK" + increment

    # Apply currency
    @sfx_pack.currency = @designer.user.legal_entity.payment_infos.last.preferred_currency.downcase
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

    # Applying currency
    @sfx_pack.currency = @designer.user.legal_entity.payment_infos.last.preferred_currency.downcase

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
    params.require("sfx_pack").permit(:title, :size_mb, :description, :photos, :price, :number_of_tracks, :duration, :link, :product_link, :sound_list, :sample_rate, :bit_depth)
  end
end
