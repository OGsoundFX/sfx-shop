namespace :jobs do
  desc "TODO"
  task clear_outdated: :environment do
    # fetching links older then their validity date
    outdated_links = DownloadLink.select { |link| (Time.zone.now - link.created_at) > link.validity_duration.to_i}

    # destroying these links and corresponding ZipCollectionJob jobs
    outdated_links.each do |link|
      if link.job_id.present? &&  SolidQueue::Job.find_by(active_job_id: link.job_id)
        SolidQueue::Job.find_by(active_job_id: link.job_id).destroy
      end
      link.destroy
    end

    # fetching ZipCollectionJob jobs that are not connected to a download_link
    idle_jobs = SolidQueue::Job.where(class_name: "ZipCollectionJob").where.not(active_job_id: DownloadLink.select(:job_id))
    # fetching all jobs older then 2 days
    old_jobs = SolidQueue::Job.where("created_at < ?", 2.days.ago)

    # Removing idle and old jobs
    idle_jobs.destroy_all
    old_jobs.destroy_all
  end
end
