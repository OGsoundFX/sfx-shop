class DesignerDashboardsController < ApplicationController
  before_action :unauthorized_redirect, :load_designer

  def main
  end

  def submissions
    # @live_packs = @designer.sfx_packs.live.order(updated_at: :desc)
    # @pending_packs = @designer.sfx_packs.pending.order(updated_at: :desc)
    # @under_review_packs = @designer.sfx_packs.under_review.order(updated_at: :desc)
    # @declined_packs = @designer.sfx_packs.declined.order(updated_at: :desc)

    @packs = @designer.sfx_packs.where.not(id: 100).order(:status)
  end

  def pack_form
    @designer = current_user.sound_designer
    @sfx_pack = SfxPack.new
  end

  private

  def load_designer
    @designer = current_user.sound_designer
  end

  def unauthorized_redirect
    redirect_to root_path, notice: "You need to sign in to access this page" if !user_signed_in?
  end
end
