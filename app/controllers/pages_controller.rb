class PagesController < ApplicationController
  def home
    @designers = SoundDesigner.all
    # includes makes sure that the sound_designer from separate table and attachment are loaded in the request
    # rather then each attachment and sound_designere loaded separatly on html display (in iteration)
    @sfx_packs = SfxPack.includes(:sound_designer).includes(photos_attachments: :blob).all.sort_by(&:display_order)
    if Date.today < Annoucement.last.end_date && Date.today >= Annoucement.last.start_date
      @announcement = Annoucement.last
    end

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

    if current_user
      audience_id = ENV['MAILCHIMP_LIST_ID']
      begin
        @status = Gibbon::Request.lists(audience_id).members(current_user.email).retrieve.body["status"]
      rescue
        @status = "Not Subscribed"
      end
    end

  end

  def data_protection
  end

  def subscribe
    SubscribeToNewsletterNoUserService.new(params[:email][:email]).call
    session[:subscribed] = true
  end

  def about
  end

  def eula
  end

  def blog
  end

  def the_quest
  end
end
