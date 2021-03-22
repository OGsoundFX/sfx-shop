class AdministratorController < ApplicationController
  def admin
    redirect_to root_path if current_user.nil? || current_user.email != 'olivier@ogsoundfx.com'
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

    pack_hash = {
      "Monster SFX Pack" => 0,
      "Guns and Explosions"=> 0,
      "Outdoor Atmospheres"=> 0,
      "Underground Atmospheres"=> 0,
      "Natural Disasters"=> 0,
      "Ghost & Haunted"=> 0,
      "Weather Effects"=> 0
    }
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
end
