class CartsController < ApplicationController
  before_action :authenticate_user!
  def cart_order
    if Cart.where(user_id: current_user.id).count == 1
      @items = Cart.where(user_id: current_user.id).first
      @items.items << SfxPack.find(params[:pack_id]).id.to_i
      @items.items.uniq!
    else
      # check which of the 2 lines bellow is correct
      # @items = Cart.create(user_id: current_user.id).first
      @items = Cart.create(user_id: current_user.id)
      @items.items = []
      @items.items << SfxPack.find(params[:pack_id]).id.to_i
    end
    @items.save
    redirect_to root_path(anchor: "front-title")
  end

  def cart
    @items = Cart.where(user_id: current_user.id).first
    current_sales = Sale.where("end_date > ?", Date.current)
    @current_sales_list = {}

    # listing all packs to sort them by price to display them and apply discount to 2nd and other packs
    if @items
      @pack_list = []
      @items.items.each do |item|
        @pack_list << SfxPack.find(item)
      end
      @total_value = 0
      @sum = 0

      current_sales.each do |sale|
        sale.packs.each do |pack_id|
          @current_sales_list[pack_id] = sale.percentage
        end
      end

      if current_sales.count > 0
        @pack_list.each do |pack|
          @current_sales_list[pack.id] ? @sum += (pack.price_cents * ((100 - @current_sales_list[pack.id]) / 100.to_f)) / 100 : @sum += (pack.price_cents / 100)
          @total_value += (pack.price_cents / 100)
        end

      else
        @pack_list.sort_by!(&:price_cents).reverse!
        @pack_list.each_with_index do |pack, index|
          @total_value += (pack.price_cents / 100)
          index.positive? ? @sum += ((pack.price_cents / 100) * 0.8) : @sum += (pack.price_cents / 100)
        end
      end
    end
  end

  def delete_item
    @cart = Cart.where(user_id: current_user.id).first
    @cart.items.delete(params[:pack_id].to_i)
    if @cart.items == []
      @cart.destroy
    else
      @cart.save
    end
    if params[:remain] == "true"
      redirect_to root_path
    else
      redirect_to cart_path
    end
  end

  def destroy_cart
    Cart.where(user_id: current_user.id).first.destroy
    redirect_to dashboard_path
  end
end
