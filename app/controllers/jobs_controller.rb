class JobsController < ApplicationController

  def destroy
    job = SolidQueue::Job.find_by(active_job_id: params[:job_id])
    job.destroy if job.present?

    head :no_content
  end
end
