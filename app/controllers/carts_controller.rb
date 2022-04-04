class CartsController < ApplicationController
  before_action :authenticate_user!

  # despite the terrible naming choice, cart_order is the action for "adding SfxPacks to the cart"
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
      @items.sinlge_tracks = []
      @items.items << SfxPack.find(params[:pack_id]).id.to_i
    end
    @items.save
    redirect_to root_path(anchor: "front-title")
  end

  # adding single tracks to Cart
  def single_tracks
    if Cart.where(user_id: current_user.id).count == 1 && Cart.where(user_id: current_user.id).first.sinlge_tracks != nil
      @tracks = Cart.where(user_id: current_user.id).first
      @tracks.sinlge_tracks << SingleTrack.find(params[:track_id]).id.to_i
      @tracks.sinlge_tracks.uniq!
    elsif Cart.where(user_id: current_user.id).count == 1 && Cart.where(user_id: current_user.id).first.sinlge_tracks == nil
      @tracks = Cart.where(user_id: current_user.id).first
      @tracks.sinlge_tracks = []
      @tracks.items = []
      @tracks.sinlge_tracks << SingleTrack.find(params[:track_id]).id.to_i
      @tracks.sinlge_tracks.uniq!
    else
      @tracks = Cart.create(user_id: current_user.id)
      @tracks.sinlge_tracks = []
      @tracks.items = []
      @tracks.sinlge_tracks << SingleTrack.find(params[:track_id]).id.to_i
    end
    @tracks.save
    redirect_to request.referer
  end

  def cart
    collections

    # adding collection(s) to cart
    cart = current_user.cart
    cart.collections << @current_collections.last.id
    cart.collections.uniq!
    cart.save

    # Set a few variables
    @number_of_items = @current_collections.count
    @items = Cart.where(user_id: current_user.id).first
    current_sales = Sale.where("end_date > ?", Date.current)
    @current_sales_list = {}

    # listing all packs to sort them by price to display them and apply discount to 2nd and other packs
    if @items
      @pack_list = []
      @items.items.each do |item|
        @pack_list << SfxPack.find(item)
      end
      @number_of_items += @pack_list.count
      # fetching single tracks
      @single_tracks_list = []
      @items.sinlge_tracks.each do |item|
        SingleTrack.find_by_id(item) ? @single_tracks_list << SingleTrack.find(item) : false
      end
      @number_of_items += @single_tracks_list.count
      @total_value = 0
      @sum = 0

      current_sales.each do |sale|
        sale.packs.each do |pack_id|
          @current_sales_list[pack_id] = sale.percentage
        end
      end

      # adding up prices of Packs depending on sales or not and usual 20% discount
      if current_sales.count > 0
        @pack_list.each do |pack|
          @current_sales_list[pack.id] ? @sum += (pack.price_cents * ((100 - @current_sales_list[pack.id]) / 100.to_f)) / 100 : @sum += (pack.price_cents / 100)
          @total_value += (pack.price_cents / 100)
        end
        @total_pack_sum = @sum
      else
        @pack_list.sort_by!(&:price_cents).reverse!
        @pack_list.each_with_index do |pack, index|
          @total_value += (pack.price_cents / 100)
          index.positive? ? @sum += ((pack.price_cents / 100) * 0.8) : @sum += (pack.price_cents / 100)
        end
        @total_pack_sum = @sum
      end

      # adding up prices of single tracks
      @single_tracks_value = 0

      @single_tracks_list.each do |track|
        @single_tracks_value += (track.price_cents / 100.to_f)
        @sum += (track.price_cents / 100.to_f)
        @total_value += (track.price_cents / 100.to_f)
      end

      # adding up price of collection
      @sum += @current_collections.last.price_cents / 100
      # this is the You spare part, if we do it with collections vs single tracks
      # @total_value += @current_collections.last.price_cents / 100
      single_tracks_price = 0
      @current_collections.last.tracks.each { |track| single_tracks_price += (SingleTrack.find(track).price_cents / 100.to_f) }
      @total_value += single_tracks_price
      @icons = {
        "all": '<i class="fas fa-volume-up"></i>',
        "action": '<i class="fas fa-swords"></i>',
        "medieval": '<i class="fab fa-fort-awesome"></i>',
        "outdoor":	'<i class="fas fa-trees"></i>',
        "underground": '<i class="fas fa-dungeon"></i>',
        "scary":	'<i class="fas fa-ghost"></i>',
        "monsters":	'<i class="fas fa-dragon"></i>',
        "disasters": '<i class="fas fa-volcano"></i>',
        "weather": '<i class="fas fa-cloud-showers-heavy"></i>',
        "default": '<i class="fas fa-volume-up"></i>'
      }
      # @tracks = SingleTrack.where(id: [@items.sinlge_tracks]).page params[:page]
      @tracks = SingleTrack.where(id: [@items.sinlge_tracks])
    end
  end

  def delete_item
    @cart = Cart.where(user_id: current_user.id).first
    @cart.items.delete(params[:pack_id].to_i)
    if @cart.items.empty? && @cart.sinlge_tracks.empty? && @cart.collections.empty?
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

  def delete_track
    cart = Cart.where(user_id: current_user.id).first
    cart.sinlge_tracks.delete(params[:id].to_i)
    if cart.items.empty? && cart.sinlge_tracks.empty? && cart.collections.empty?
      cart.destroy
    else
      cart.save
    end
    redirect_to cart_path
  end

  def single_tracks_cart_remove
    cart = Cart.where(user_id: current_user.id).first
    cart.sinlge_tracks.delete(params[:track_id].to_i)
    if cart.items.empty? && cart.sinlge_tracks.empty? && cart.collections.empty?
      cart.destroy
    else
      cart.save
    end
    if params[:page]
      redirect_to list_path(page: params[:page])
    else
      redirect_to cart_path
      #what is going on?
    end
  end

  def destroy_cart
    Cart.where(user_id: current_user.id).first.destroy
    redirect_to dashboard_path
  end

  private

  def collections
    @past_collections = Collection.where("user_id = #{current_user.id} AND purchased = true")
    @current_collections = Collection.where("user_id = #{current_user.id} AND purchased = false")
  end
end
