class PagesController < ApplicationController
  def home
    @categories = SfxPack.categories
    @designers = SoundDesigner.all
    # includes makes sure that the sound_designer from separate table and attachment are loaded in the request
    # rather then each attachment and sound_designere loaded separatly on html display (in iteration)
    @sfx_packs = SfxPack.where(status: "live").includes(:sound_designer).includes(photos_attachments: :blob).all.sort_by(&:display_order)
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
    email = params[:email][:email]
    if email.match?(/\A[^@\s!"§$%&\/()=?`´,;]{4,}+@[^@\s!"§$%&\/()=?`´,;]+[.][a-z]{2,}/)
      SubscribeToNewsletterNoUserService.new(params[:email][:email]).call
      session[:subscribed] = true
      session[:modal_closed] = true
      redirect_to root_path, notice: "Succesfully subscribed with email address #{email}"
    else
      redirect_to root_path, alert: "Invalid email address #{email}"
    end
  end

  def about
  end

  def eula
  end

  def blog
  end

  def the_quest
  end

  def modal_closed
    session[:modal_closed] = true
  end
end
