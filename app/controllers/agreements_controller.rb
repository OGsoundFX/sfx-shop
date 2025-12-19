class AgreementsController < ApplicationController
  before_action :authenticate_user!

  def show
    @agreement = Agreement.find_by!(key: params[:key], version: params[:version])
  end
end
