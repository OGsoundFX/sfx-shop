class SalesController < ApplicationController
  def new
    @sale = Sale.new
  end

  def create
    Sale.delete_all if Sale.count > 0
    @sale = Sale.new(sale_params)
    @sale.save
  end

  private

  def sale_params
  end
end
