class SalesController < ApplicationController
  def new
    @sale = Sale.new
  end

  def create
    Sale.delete_all if Sale.count > 0
    @sale = Sale.new(sale_params)
    @sale.save
    redirect_to admin_path
  end

  private

  def sale_params
    params.require(:sale).permit(:title, :percentage, :start_date, :end_date, :packs)
  end
end
