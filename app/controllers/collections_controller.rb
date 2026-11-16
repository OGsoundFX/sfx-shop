class CollectionsController < ApplicationController
  before_action :authenticate_user!, except: [
    :templates_index,
    :templates_show,
    :pack_builder,
    :create_builder_pack,
    :add_builder_track,
    :remove_builder_track,
    :remove_builder_collection
  ]

  # ! Pack builder section 👇
  def pack_builder
    @collection = pack_builder_user&.collections&.where(purchased: false)&.last
    @search = params[:search].presence if params[:search].is_a?(String)
    @dropdown = params[:dropdown].presence if params[:dropdown].is_a?(String)
    @includes_ai = params[:includes_ai] if %w[true false].include?(params[:includes_ai])
    @asset_type = params[:asset_type] if SingleTrack.asset_types.key?(params[:asset_type])

    @icons = CategoryIcons.all

    @categories = SfxPack.categories
    @categories.unshift('All')

    tracks = SingleTrack.all
    tracks = tracks.where(category: @dropdown.downcase) if @dropdown.present? && @dropdown.downcase != "all"
    tracks = tracks.search_single_tracks(@search) if @search.present?
    tracks = tracks.where(includes_ai: @includes_ai == "true") if @includes_ai.present?
    tracks = tracks.where(asset_type: @asset_type) if @asset_type.present?

    @total_sounds = tracks.count
    tracks = tracks.order('RANDOM()')
    @sfx_tracks = tracks.page(params[:page]).per(20)
  end

  def create_builder_pack
    track = SingleTrack.find params[:track]
    user = pack_builder_user(create: true)
    collection = user.collections.where(purchased: false).last ||
      user.collections.new(tracks: [], total_points: 0, price_cents: 0)
    add_track_to_builder_collection(collection, track)
  end

  def add_builder_track
    track = SingleTrack.find params[:track]
    user = pack_builder_user
    return head :not_found unless user

    collection = user.collections.where(purchased: false).find(params[:collection])
    add_track_to_builder_collection(collection, track)
  end

  def remove_builder_track
    user = pack_builder_user
    return head :not_found unless user

    collection = user.collections.where(purchased: false).find(params[:collection_id])
    track = SingleTrack.find(params[:track_id])
    collection_track_ids = (collection.tracks || []).map(&:to_i) - [track.id]
    update_builder_collection(collection, collection_track_ids, track)
  end

  def remove_builder_collection
    user = pack_builder_user
    return head :not_found unless user

    collection = user.collections.where(purchased: false).find(params[:collection_id])
    collection.destroy

    if (cart = user.cart)
      cart.collections = user.collections.where(purchased: false).pluck(:id)
      if cart.items.blank? && cart.sinlge_tracks.blank? && cart.collections.blank?
        cart.destroy
      else
        cart.save
      end
    end
    redirect_to pack_builder_path
  end

  # ! Pack builder section 👆

  def create
    # this action is not only to create a collection from scratch but add tracks to collection
    user_collection = Collection.where("user_id = #{current_user.id} and purchased = false").last
    if !user_collection.nil?
      user_collection.tracks << params[:track].to_i
      user_collection.tracks = user_collection.tracks.uniq
      user_collection.total_points = points(user_collection.tracks)
      user_collection.price_cents = collection_categories(user_collection.total_points)
      user_collection.save
    else
      Collection.create(user_id: current_user.id, tracks: [params[:track].to_i], total_points: SingleTrack.find(params[:track].to_i).points, price_cents: 500)
    end
    if !current_user.cart.nil?
      cart = current_user.cart
      cart.sinlge_tracks.delete(params[:track].to_i)
      cart.save
    end
    cart_create_update
    redirect_to request.referer
  end

  def update
    # this action is to remove tracks from collection
    collection = Collection.find(params[:id].to_i)
    cart = Cart.where(user_id: current_user.id).last
    collection.tracks.delete(params[:track].to_i)
    collection.total_points = points(collection.tracks)
    collection.price_cents = collection_categories(collection.total_points)
    collection.save

    # destroy collection if doesn't contain tracks
    if collection.tracks == []
      cart_remove_collection(collection, cart)
      collection.destroy
    end

    # destroy cart if empty
    cart.destroy if cart.items == [] && cart.sinlge_tracks == [] && cart.collections == []
    redirect_to request.referer
  end

  def convert
    # this action is not only to create a collection from scratch but add tracks to collection
    user_collection = Collection.where("user_id = #{current_user.id} and purchased = false").last
    if !user_collection.nil?
      params[:tracks].each do |track|
        user_collection.tracks << track.to_i
        user_collection.tracks = user_collection.tracks.uniq
        user_collection.total_points = points(user_collection.tracks)
        user_collection.price_cents = collection_categories(user_collection.total_points)
      end
      user_collection.save
    else
      price = CollectionCategory.where("points > #{params[:points]}").first.price * 100
      Collection.create(user_id: current_user.id, tracks: params[:tracks], total_points: params[:points], price_cents: price)
    end
    # Deleting all the single tracks from user
    current_user.cart.sinlge_tracks = []
    current_user.cart.save!
    redirect_to request.referer
  end

  def remove_collection_from_cart
    # this action does 4 things:
    # 1- removes a track from collection
    # 2- removes collection from cart of collection is empty
    # 3- destroys collection if collection is empty
    # 4- destroys cart when collection is destroyed if no other items in cart
    collection = Collection.find(params[:collection])
    collection.tracks.delete(params[:track].to_i)
    if collection.tracks == []
      cart = Cart.where(user_id: current_user.id).first
      cart.collections = []
      if cart.items == [] && cart.collections = [] && cart.sinlge_tracks == []
        cart.destroy
      else
        cart.save
      end
      collection.destroy
    else
      collection.total_points = points(collection.tracks)
      collection.price_cents = collection_categories(collection.total_points)
      collection.save
    end
    redirect_to cart_path
  end

  def destroy_collection
    collection = Collection.find(params[:collection])
    cart = Cart.where(user_id: current_user.id).first
    if cart.items == [] && cart.sinlge_tracks == []
      cart.destroy
      collection.destroy
    else
      cart.collections = []
      cart.save
      collection.destroy
    end
    redirect_to cart_path
  end

  def name_update
    name = name_params["input-name"]
    collection = Collection.find(params[:collection])
    collection.title = name
    collection.save
    respond_to do |format|
      format.turbo_stream {render turbo_stream: turbo_stream.replace("collection-name-#{collection.id}", partial: "collections/right_pannel_elements/collection_name", locals: {collection: collection})}
      format.html { request.referer }
    end
  end

  # /note/👇 this approach creates the zipfile and stores it on AWS
  def create_zip_collection
    if params[:type] == "single_tracks"
      params_object = {order: params[:order], tracks: params[:tracks], type: params[:type]}
    else
      params_object = {order: params[:order], collection: params[:collection]}
    end
    ZipCollectionJob.perform_later(params_object, current_user.id)
    redirect_to dashboard_path
  end

  def download_link_status
    order = current_user.orders.find_by(id: params[:order_id])
    return head :not_found unless order

    case params[:download_type]
    when "collection"
      collection = current_user.collections.find_by(id: Array(order.collections).first)
      return head :not_found unless collection

      download_link = collection.download_links
        .where(order: order, collection_download: true)
        .order(created_at: :desc)
        .first
      return head :no_content unless download_link && !download_link.expired?

      render turbo_stream: turbo_stream.replace(
        "dashboard-collection-download-button-#{order.id}",
        partial: "shared/dashboard_collection_download_button",
        locals: { collection: collection, order: order }
      )
    when "single_tracks"
      return head :not_found if Array(order.tracks).empty?

      download_link = order.download_links
        .where(collection_download: false)
        .order(created_at: :desc)
        .first
      return head :no_content unless download_link && !download_link.expired?

      render turbo_stream: turbo_stream.replace(
        "dashboard-tracks-download-button-#{order.id}",
        partial: "shared/dashboard_tracks_download_button",
        locals: { order: order }
      )
    else
      head :bad_request
    end
  end

  def create_template
    collection = Collection.find(params[:template][:collection])
    title = params[:template][:title]
    categories = params[:template][:categories].split(", " || "")
    template = TemplateCollection.new(title: title, total_points: collection.total_points, price: collection.price, tracks: collection.tracks, categories: categories)
    if template.save
      redirect_to cart_path
    else
      redirect_to cart_path, alert: "Invalid entry"
    end
  end

  def templates_index
    @templates = TemplateCollection.where(active: true)
    @icons = CategoryIcons.all
  end

  def templates_show
    @icons = CategoryIcons.all
    @template_collection = TemplateCollection.find(params[:id])
    @collection = Collection.where("user_id = #{current_user.id} and purchased = false").last if current_user
    @tracks = SingleTrack.where(id: @template_collection.tracks).reorder(created_at: :desc).page params[:page]
  end

  def add_template_to_cart
    convert_template_to_collection(params[:template_id])
    redirect_to cart_path
  end

  private

  def add_track_to_builder_collection(collection, track)
    collection_track_ids = (collection.tracks || []).map(&:to_i)
    collection_track_ids << track.id unless collection_track_ids.include?(track.id)
    update_builder_collection(collection, collection_track_ids, track)
  end

  def update_builder_collection(collection, collection_track_ids, changed_track)
    collection.tracks = collection_track_ids
    collection.total_points = points(collection_track_ids)
    collection.price_cents = collection_categories(collection.total_points)

    unless collection.save
      redirect_to pack_builder_path, alert: "Unable to update your collection."
      return
    end

    cart_create_update if user_signed_in?

    if "$" != session[:currency]
      conversion_rate = CurrencyRate.where("base = ? AND target = ?", "USD", "EUR").order(created_at: :desc).first.rate.to_f
    else
      conversion_rate = 1
    end
    collection_tracks = SingleTrack.where(id: collection_track_ids).index_by(&:id)
    individual_value = collection_tracks.values.sum(&:price_cents) / 100.0
    collection_savings = individual_value - collection.price.to_f

    collection_points_total = collection&.total_points || 0
    current_collection_level = CollectionCategory.where("points >= ?", collection_points_total).order(:points).first
    collection_points = CollectionCategory.where("points >= #{collection&.total_points || 0}").first.points
    next_collection = CollectionCategory.where("points >= #{collection&.total_points || 0}").second

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("pack-builder-add-button-#{changed_track.id}", partial: "add_button_pack_builder", locals: {track: changed_track, collection: collection}),
          turbo_stream.replace("right-pannel-top-track-count", partial: "collections/right_pannel_elements/top_track_count", locals: {collection: collection}),
          turbo_stream.replace("selected-track-list",
            partial: "collections/right_pannel_elements/selected_track_list",
            locals: {
              collection: collection,
              collection_track_ids: collection_track_ids,
              collection_tracks: collection_tracks,
              conversion_rate: conversion_rate
            }
          ),
          turbo_stream.replace("total_price_recap",
            partial: "collections/right_pannel_elements/total_price_recap",
            locals: {
              collection: collection,
              conversion_rate: conversion_rate,
              collection_savings: collection_savings,
              individual_value: individual_value
            }
          ),
          turbo_stream.replace("collection-progress",
            partial: "collections/right_pannel_elements/collection_progress",
            locals: {
              collection: collection,
              current_collection_level: current_collection_level,
              collection_points_total: collection_points_total,
              collection_points: collection_points,
              next_collection: next_collection
            }
          )
        ]
      end
      format.html { redirect_to pack_builder_path }
    end
  end

  def points(tracks)
    if tracks == []
      points = 0
    else
      points = tracks.map do |id|
        SingleTrack.find(id).points
      end
      points.reduce {|sum, el| sum += el}
    end
  end

  def collection_categories(points)
    case
    when points == 0
      0
    when points <= 20
      500
    when points <= 50
      1000
    when points <= 120
      2000
    when points <= 300
      4000
    else
      5000 # unlimited
    end
  end

  def cart_create_update
    if Cart.where(user_id: current_user.id).last.nil?
      Cart.create(collections: current_user_collections, user_id: current_user.id)
    else
      cart = Cart.where(user_id: current_user.id).last
      cart.collections = current_user_collections
      cart.save
    end
  end

  def current_user_collections
    current_user.collections.map {|coll| coll.id if coll.purchased == false}.compact
  end

  def cart_remove_collection(collection, cart)
    cart.collections.delete(collection.id)
    cart.save
  end

  def name_params
    params.permit("input-name")
  end

  def pack_builder_user(create: false)
    return current_user if user_signed_in?

    guest_user = User.find_by(id: session[:pack_builder_guest_user_id])
    return guest_user if guest_user
    return unless create

    guest_user = User.create!(
      email: "guest_#{SecureRandom.hex(10)}@example.com",
      password: SecureRandom.hex(10)
    )
    session[:pack_builder_guest_user_id] = guest_user.id
    guest_user
  end

  def convert_template_to_collection(id)
    if Cart.where(user_id: current_user.id).last.nil?
      Cart.create(user_id: current_user.id)
    end
    template = TemplateCollection.find(id)
    if current_user.collections.where(purchased: false).count > 0
      collection = Collection.where(user: current_user, purchased: false).first
      collection.tracks += template.tracks
      collection.tracks = collection.tracks.uniq
      collection.title = template.title
      collection.template_collection_id = template.id
      # points = collection.total_points + template.total_points
      points = points(collection.tracks)
      collection.total_points = points
      collection.price_cents = collection_categories(points)
    else
      collection = Collection.new(title: template.title, total_points: template.total_points, tracks: template.tracks, template_collection_id: template.id, price_cents: template.price_cents, user: current_user)
    end
    collection.save
  end
end
