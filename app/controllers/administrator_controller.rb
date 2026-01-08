class AdministratorController < ApplicationController
  before_action :check_admin

  # main tab
  def admin
    # removing test orders from admin user bamsfx@ogsoundfx.com (Use with id 6)
    orders = Order.joins(:user).where.not(user: { email: "olivier@bamsfx.com"})

    # total orders
    @total_orders_count = orders.where(status: "paid").count
    @total_orders_amount = orders.where(status: "paid").sum(&:amount_cents) / 100

    # current month oders
    @month_orders_count = orders.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month, status: "paid").count
    @month_orders_amount = orders.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month, status: "paid").sum(&:amount_cents) / 100

    # compared to previsous mont
    @delta_count = @month_orders_count - orders.where(created_at: Time.current.last_month.beginning_of_month..Time.current.last_month.end_of_month, status: "paid").count
    @delta_amount = @month_orders_amount - orders.where(created_at: Time.current.last_month.beginning_of_month..Time.current.last_month.end_of_month, status: "paid").sum(&:amount_cents) / 100
    # last 10 orders
    @orders = orders.where(status: "paid").last(10).reverse
  end

  def designer_submissions
    @tab = 'applications'
    @submissions = DesignerSubmission.all.order(created_at: :desc).order(:status)
  end

  def designer_legal_entities
    @tab = 'legal_entities'
    @legal_entities = LegalEntity.includes(:sound_designer, :user).order(created_at: :desc).order(:status)
  end

  def pack_submissions
    @packs = SfxPack.submitted
  end

  def submission_accepted
    submission = DesignerSubmission.find(params[:id])
    submission.accepted!
    DesignerMailer.submission_accepted(submission).deliver_later
    if User.find_by(email: submission.email)
      user = User.find_by(email: submission.email)
    else
      user = User.create(email: submission.email, password: submission.access_token, designer: true)
    end
    user.designer = true
    user.save
    submission.update(user: user)
    redirect_to submissions_path
  end

  def submission_rejected
    DesignerSubmission.find(params[:id]).rejected!
    redirect_to submissions_path
  end

  def pack_accepted
    @pack = SfxPack.find(params[:id])
    @pack.live!
    PackPublishedMailer.approved(@pack).deliver_later
    redirect_to pack_submissions_path
  end

  def pack_rejected
    # probably need a form for rejection reasons
    raise
  end

  def calculate_exchange_rate
    RateConversionJob.perform_now
    redirect_to admin_path
  end

  def stats
    paid_orders = Order.where(status: "paid")

    orders = Order.all
    @amount_earned_today = 0
    orders.each do |order|
      @amount_earned_today += order.amount_paid_cents if order.created_at.strftime('%Y-%m-%d') == Date.today.strftime('%Y-%m-%d')
    end

    @paid_orders = paid_orders.count
    @buyers = Order.group(:user_id).count.sort_by{ |key, value| -value }.to_h.count
    @top_five = Order.group(:user_id).count.sort_by{ |key, value| -value }[0..4].to_h
    # @top_five_amount = Order.group(:user_id, :amount_cents).count.sort_by{ |key, value| -value }[0..4].to_h

    @carts = Cart.count
    @items_in_carts = Cart.all.inject(0) { |sum, cart| sum + cart.items.count }

    pack_hash = {}

    SfxPack.pluck(:title).each do |pack|
      pack_hash[pack] = 0
    end

    paid_orders.each do |order|
      if order.multiple
        order.packs.each do |pack|
          pack_hash[SfxPack.find(pack).title] += 1
        end
      else
        pack_hash[SfxPack.find(order.sfx_pack_id).title] += 1
      end
    end
    @packs = pack_hash.sort_by {|_key, value| -value}.to_h
  end

  def sales
    @all_sales = Sale.all
    @current_sales = Sale.where("end_date > ?", Date.current)
    @previous_sales = Sale.where("end_date <= ?", Date.current).order(end_date: :desc)
    @sale = Sale.last
  end

  def payouts
    currency_rate = CurrencyRate.where(base: "USD", target: "EUR").last.rate
    @designers = SoundDesigner.joins(:sold_items).distinct.includes(:sold_items)
    @total_payout_eur = SoldItem.pending.sum do |sold_item|
      sold_item.payout_currency == "eur" ? sold_item.payout_amount_cents : 0
    end / 100.0

    @total_payout_usd = SoldItem.pending.sum do |sold_item|
      sold_item.payout_currency == "usd" ? sold_item.payout_amount_cents : 0
    end / 100.0

    @due_payouts = @designers.map do |designer|
      sold_items = designer.sold_items.pending.order(created_at: :desc)
      amount_due = sold_items.sum(:payout_amount_cents)
      # due date calculation
      if amount_due >= 50
        month = Date.today.month == 12 ? 1 : Date.today.month + 1
        year = Date.today.month == 12 ? Date.today.year + 1 : Date.today.year
        due_date = Date.new(year, month, 01)
      else
        "payment threshold not reached"
      end

      {
        due_date: due_date,
        paypal_account: designer.user.legal_entity.payment_infos.last.paypal_account,
        amount_due_cents: amount_due,
        currency: designer.user.legal_entity.payment_infos.last.preferred_currency,
        sold_items: sold_items,
        designer: designer,
        time_period: [sold_items.first.created_at, sold_items.last.created_at]
      }
    end

    @past_payouts = Payout.paid.order(payout_date: :desc)
  end

  def agreements
    @agreements = Agreement.order(version: :desc)
  end

  private

  def check_admin
    if current_user.nil? || current_user.email != 'olivier@bamsfx.com'
      redirect_to root_path, alert: "You are not authorised to visit this page"
    end
  end
end
