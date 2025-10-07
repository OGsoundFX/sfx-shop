class AdministratorController < ApplicationController
  before_action :check_admin

  # main tab
  def admin
    # removing test orders from admin user olivier@ogsoundfx.com (Use with id 6)
    orders = Order.joins(:user).where.not(user: { email: "olivier@ogsoundfx.com"})

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
    @submissions = DesignerSubmission.all.order(:status)
  end

  def submission_accepted
    submission = DesignerSubmission.find(params[:id])
    submission.accepted!
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

  private

  def check_admin
    if current_user.nil? || current_user.email != 'olivier@ogsoundfx.com'
      redirect_to root_path, alert: "You are not authorised to visit this page"
    end
  end
end
