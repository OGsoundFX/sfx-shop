class DesignerSubmissionsController < ApplicationController
  before_action :find_designer_submission, only: [:show, :update]

  def new
    @designer_submission = DesignerSubmission.new
    @designer_submission.submission_links.build
  end

  def create
    @designer_submission = DesignerSubmission.new(designer_submission_params)
    @designer_submission.profile_created!
    if @designer_submission.save
      redirect_to designer_submission_url(access_token: @designer_submission.access_token), notice: "Information successfully submitted"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @submission_link = SubmissionLink.new
  end

  def update
    @designer_submission.update(designer_submission_params)
    redirect_to designer_submission_path(@designer_submission), notice: "Information successfully submitted"
  end

  def thank_you
    @designer_submission = DesignerSubmission.find(params[:id])
    @designer_submission.submited!
    @designer_submission.save
  end

  private

  def designer_submission_params
    params.require(:designer_submission).permit(:first_name, :last_name, :email, :location, :individual_tracks)
  end

  def find_designer_submission
    # @designer_submission = DesignerSubmission.find(params[:id])
    @designer_submission = DesignerSubmission.find_by!(access_token: params[:access_token])
  end
end
