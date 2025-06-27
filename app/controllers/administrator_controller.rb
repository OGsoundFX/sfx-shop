class AdministratorController < ApplicationController
  before_action :check_admin

  def admin
    @all_sales = Sale.all
    @current_sales = Sale.where("end_date > ?", Date.current)
    @sale = Sale.last

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

  def designer_submissions
    @submissions = DesignerSubmission.all.order(:status)
  end

  def submission_accepted
    DesignerSubmission.find(params[:id]).accepted!
    redirect_to submissions_path
  end

  def submission_rejected
    DesignerSubmission.find(params[:id]).rejected!
    redirect_to submissions_path
  end

  private

  def check_admin
    if current_user.nil? || current_user.email != 'olivier@ogsoundfx.com'
      redirect_to root_path, alert: "You are not authorised to visit this page"
    end
  end
end
