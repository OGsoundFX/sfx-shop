class SubmissionLinksController < ApplicationController
  def create
    @submission_link = SubmissionLink.new(link_params)
    @designer_submission = DesignerSubmission.find(params[:designer_submission_id])
    @submission_link.designer_submission = @designer_submission
    if @submission_link.save
      redirect_to designer_submission_path(@designer_submission)
    else
      render "designer_submissions/show", status: :unprocessable_entity
    end
  end

  def destroy
    submission_link = SubmissionLink.find(params[:id])
    submission_link.destroy
    redirect_to designer_submission_path(submission_link.designer_submission)
  end

  private

  def link_params
    params.require(:submission_link).permit(:url, :title, :description)
  end
end
