class SoundDesignersController < ApplicationController
  def new
    if user_signed_in? && current_user.designer && current_user.sound_designer.nil?
      @sound_designer = SoundDesigner.new
      @payment_info = PaymentInfo.new
    else
      if !user_signed_in?
        redirect_to root_path, notice: "You must be logged in to create a Sound Designer profile."
      elsif !current_user.designer
        redirect_to root_path, notice: "You must be approved as a Sound Designer to create a Sound Designer profile. Please contact us if you think this is an error."
      else
        redirect_to root_path, notice: "You already have a Sound Designer profile."
      end
    end
  end

  def create
    @sound_designer = SoundDesigner.new(sound_designer_params)
    if @sound_designer.save
      redirect_to root_path, notice: "Sound Designer profile created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def sound_designer_params
    params.require(:sound_designer).permit(:first_name, :last_name, :address, :location, :bio)
  end
end
