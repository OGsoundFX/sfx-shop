class SfxPacksController < ApplicationController
  def show
    @pack = SfxPack.includes(:sound_designer).includes(photos_attachments: :blob).find(params[:id])
    @designer = @pack.sound_designer
    @designer_name = "#{@designer.first_name} #{@designer.last_name}"
    @average_rating = (@pack.reviews.sum { |review| review.rating } / @pack.reviews.count.to_f).ceil(1) if @pack.reviews.present?
    current_sales = Sale.where("end_date > ?", Date.current)
    current_sales.each do |sale|
      sale.packs.each do |pack_id|
        @discount = sale.percentage if @pack.id == pack_id
      end
    end
  end
end
