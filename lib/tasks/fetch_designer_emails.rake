namespace :fetch_designer_emails do
  desc 'Fetch emails from designer submissions that have not created their profile yet'
  task fetch_submissions_emails: :environment do
    puts DesignerSubmission.accepted.where(completed: false).pluck(:email)
  end

  desc 'Fetch emails of all onboarded designers'
  task fetch_designers_emails: :environment do
    puts User.joins(:sound_designer).where(admin: false).pluck(:email)
  end

  desc 'Fetch designers emails who have not submitted any packs yet'
  task fetch_unsubmitted_packs_emails: :environment do
    puts User.joins(:sound_designer)
      .where(admin: false)
      .left_joins(sound_designer: :sfx_packs)
      .joins(:legal_entity)
      .where(legal_entity: {status: 'accepted'})
      .where(sfx_packs: { id: nil})
      .distinct.pluck(:email)
  end
end
