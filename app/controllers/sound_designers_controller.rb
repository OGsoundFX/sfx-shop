class SoundDesignersController < ApplicationController
  def show
    @designer = SoundDesigner.find(params[:id])
    @sfx_packs = @designer.sfx_packs.where(status: "live")

    # search features
    if params[:dropdown] && params[:dropdown] != "all"
      @sfx_packs = @sfx_packs.where("title ilike :query OR category ilike :query OR tags ilike :query", query: "%#{params[:dropdown]}%").includes(photos_attachments: :blob).sort_by(&:display_order)
      @category = params[:dropdown]
    end

    if params[:search]
      @sfx_packs = SfxPack.where(status: "live").where("title ilike :query OR category ilike :query OR tags ilike :query OR description ilike :query", query: "%#{params[:search]}%").includes(:sound_designer).includes(photos_attachments: :blob).sort_by(&:display_order)
      @search = params[:search]
    end

    # sales
    current_sales = Sale.where("end_date > ?", Date.current)
    @current_sales_list = {}
    current_sales.each do |sale|
      sale.packs.each do |pack_id|
        @current_sales_list[pack_id] = sale.percentage
      end
    end

    @categories = SfxPack.categories

  end

  def new
    if user_signed_in? && current_user.designer && current_user.sound_designer.nil?
      @sound_designer = SoundDesigner.new
      @payment_info = @sound_designer.payment_infos.build
    else
      if !user_signed_in?
        redirect_to root_path, notice: "You must be logged in to create a Sound Designer profile."
      elsif !current_user.designer
        redirect_to root_path, notice: "You must be approved as a Sound Designer to create a Sound Designer profile. Please contact us if you think this is an error."
      else
        redirect_to root_path, notice: "You already have a Sound Designer profile."
      end
    end
  end

  def create
    @sound_designer = SoundDesigner.new(sound_designer_params)
    if @sound_designer.save
      redirect_to root_path, notice: "Sound Designer profile created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def sound_designer_params
    params.require(:sound_designer).permit(:first_name, :last_name, :address, :location, :bio, :photo, payment_infos_attributes: [:paypal_account, :preferred_currency]).merge(user: current_user)
  end
end
